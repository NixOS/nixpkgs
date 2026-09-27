{
  pkgs,
  lib,
  addSettings,
}:

addSettings pkgs.stack (finalAttrs: ''
  ISABELLE_STACK="${lib.getExe finalAttrs.finalPackage}"
'')
