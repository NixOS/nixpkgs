{
  addSettings,
  pkgs,
  lib,
}:

addSettings pkgs.csdp (finalAttrs: ''
  ISABELLE_CSDP="${lib.getExe' finalAttrs.finalPackage "csdp"}"
'')
