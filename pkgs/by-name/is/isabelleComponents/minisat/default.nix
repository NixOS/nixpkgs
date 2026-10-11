{
  pkgs,
  addSettings,
  lib,
}:

addSettings pkgs.minisat (finalAttrs: ''
  MINISAT_HOME=${finalAttrs.finalPackage}
  ISABELLE_MINISAT=${lib.getExe' finalAttrs.finalPackage "minisat"}
'')
