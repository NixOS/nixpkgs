{
  lib,
  bash,
  patchcil,
  makeSetupHook,
}:

makeSetupHook {
  name = "auto-patchcil-hook";
  substitutions = {
    shell = lib.getExe bash;
    patchcil = lib.getExe patchcil;
  };
  meta.license = lib.licenses.mit;
} ./auto-patchcil.sh
