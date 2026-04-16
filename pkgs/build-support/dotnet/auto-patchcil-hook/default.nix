{
  lib,
  bash,
  patchcil,
  makeSetupHook,
}:

makeSetupHook {
  name = "auto-patchcil-hook";
  substitutions = {
    shell = bash.exe;
    patchcil = patchcil.exe;
  };
} ./auto-patchcil.sh
