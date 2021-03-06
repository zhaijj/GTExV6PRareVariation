# =======================================================================================================
# This is a script for generating EDF9d: association between ASE and RIVER scores
#
# output:
#       1. EDF9d.pdf (High association between RIVER scores and allelic imbalance)
#       2. EDF9d.out.RData
#          Store all data used and generated by running this script
#
# Note that the final figure was slightly modified by using inkscape for visualization purposes
#
# =======================================================================================================

#!/usr/bin/env Rscript

# Recall required packages
rm(list=ls(all=TRUE))
require(data.table)
require(ggplot2)

# Master directory
dir = Sys.getenv('RAREVARDIR')

# Recall required functions



# =========== Main
colors = c('mediumpurple','dodgerblue')
names(colors) = c("Genomic annotation model\nP(FR | G)", "RIVER\nP(FR | G, E)")
dat <- data.frame(threshold = factor(c("60%", "70%", "80%", "90%", "60%", "70%", "80%", "90%")), 
                  model= as.character(c("Genomic annotation model\nP(FR | G)", "Genomic annotation model\nP(FR | G)", 
                                        "Genomic annotation model\nP(FR | G)", "Genomic annotation model\nP(FR | G)", 
                                        "RIVER\nP(FR | G, E)", "RIVER\nP(FR | G, E)", "RIVER\nP(FR | G, E)", "RIVER\nP(FR | G, E)"), 
                                      levels=c("Genomic annotation model\nP(FR | G)", "RIVER\nP(FR | G, E)")), 
                  pvalue=c(1.74776184082, 1.59130449747, 1.97592324838, 2.31964174449, 
                           4.3831885589, 8.89927350802, 9.33225955838, 22.8134807196)) # Pre-computed P-values

ggplot(data=dat, aes(x=model, y=pvalue, fill=model, alpha = threshold)) + 
  geom_bar(stat="identity", position=position_dodge()) + 
  scale_alpha_discrete(range = c(0.3, 1), 
                       name = 'Posterior probability threshold', 
                       breaks=c("60%", "70%", "80%", "90%")) + 
  theme_bw() + 
  guides(alpha = guide_legend(title.theme = element_text(size=12,angle=0),
                              override.aes = list(fill = 'darkgrey'), title.position = "top")) + 
  scale_fill_manual(values = colors, guide = F) + 
  xlab('') + ylab(expression(paste(-log [10] , "(",italic("P"),")",sep=""))) + 
  theme(axis.title = element_text(size = 14), 
        panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank(), 
        axis.text.x = element_text(size=12), 
        axis.text.y = element_text(size=12), 
        legend.key = element_blank(), 
        legend.text=element_text(size=12),
        legend.position = c(0.3, 0.9), 
        legend.direction = 'horizontal')
ggsave(paste(dir,"/paper_figures/EDF9d.pdf",sep=""),width=6,height=4.5)



# =========== Save data
save.image(file = paste(dir,"/data/EDF9d.out.RData",sep=""))