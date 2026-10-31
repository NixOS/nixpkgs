{
  mlton20241230,
  addSettings,
  lib,
  stdenv,
}:

addSettings mlton20241230 (finalAttrs: ''
  MINISAT_HOME=${finalAttrs.finalPackage}
  ISABELLE_MLTON=${lib.getExe' finalAttrs.finalPackage "mlton"}
  ISABELLE_MLTON_OPTIONS="${lib.optionalString stdenv.hostPlatform.isLinux "-pi-style npi"}"
'')
