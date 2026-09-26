{
  texlivePackages,
  runCommand,
  addSettings,
}:
addSettings
  (runCommand "llncs" { } ''
    mkdir -p $out
    ln -s ${texlivePackages.llncs.tex}/tex/latex/llncs/llncs.cls $out/llncs.cls
    ln -s ${texlivePackages.llncs.tex}/bibtex/bst/llncs/splncs04.bst $out/splncs04.bst
  '')
  (finalAttrs: ''
    ISABELLE_LLNCS_HOME=${finalAttrs.finalPackage}
  '')
