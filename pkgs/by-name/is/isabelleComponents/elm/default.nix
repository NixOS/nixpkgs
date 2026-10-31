{ elmPackages, addSettings }:

addSettings elmPackages.elm (finalAttrs: ''
  ISABELLE_ELM_HOME="${finalAttrs.finalPackage}/bin"
'')
