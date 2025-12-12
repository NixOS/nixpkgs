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
} ./auto-patchcil.sh
