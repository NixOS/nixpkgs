{
  addSettings,
  pkgs,
  lib,
}:

addSettings pkgs.opam (finalAttrs: ''
  ISABELLE_OPAM="${lib.getExe' finalAttrs.finalPackage "opam"}"
'')
