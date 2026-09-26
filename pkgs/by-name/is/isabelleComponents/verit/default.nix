{
  pkgs,
  addSettings,
  lib,
}:

addSettings pkgs.verit (finalAttrs: ''
  ISABELLE_VERIT=${lib.getExe' finalAttrs.finalPackage "veriT"}
'')
