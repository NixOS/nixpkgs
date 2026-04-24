{
  lib,
  stdenv,
  makeSetupHook,
  replaceVars,
  targetPackages,
  prune-electron,
  makeBinaryWrapper,
}:
assert (lib.assertMsg (!targetPackages ? raw) "autoWrapElectronHook must be in nativeBuildInputs");
makeSetupHook
  {
    name = "auto-wrap-electron-hook";
    propagatedBuildInputs = [
      prune-electron
      makeBinaryWrapper
    ];
  }
  (
    replaceVars ./auto-wrap-electron.sh {
      ELECTRON_PACKAGE =
        if stdenv.hostPlatform.isLinux then targetPackages.electron else targetPackages.electron-bin;
    }
  )
