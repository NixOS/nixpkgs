#!/usr/bin/env Rscript
library(desc)

# Taken from the `generate-r-packages.R` script
escapeName <- function(name) {
    gsub(".", "_", switch(name, "import" = "r_import", "assert" = "r_assert", name), fixed=TRUE)
}


desc_path <- commandArgs(trailingOnly=TRUE)[1]
parsed_desc <- desc(desc_path)
deps <- parsed_desc$get_deps()
deps <- deps[deps$type %in% c("Depends", "Imports", "LinkingTo"), ]
dep_names <- deps$package

# Filter out the default packages coming from the R installation (and R itself)
default_pkg_names <- rownames(installed.packages(priority = "base"))
dep_names <- setdiff(dep_names, c(default_pkg_names, "R"))

cat('["')
cat(sapply(dep_names, escapeName), sep = '", "')
cat('"]')
