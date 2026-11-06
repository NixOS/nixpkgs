{ pkgs, addSettings }:

addSettings pkgs.zipperposition (finalAttrs: ''
  ZIPPERPOSITION_HOME=${finalAttrs.finalPackage}/bin
'')
