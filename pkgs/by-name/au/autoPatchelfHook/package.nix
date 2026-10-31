{
  lib,
  makeSetupHook,
  auto-patchelf,
  bintools,
  stdenv,
}:

makeSetupHook {
  name = "auto-patchelf-hook";
  propagatedBuildInputs = [
    auto-patchelf
    bintools
  ];
  substitutions = {
    hostPlatform = stdenv.hostPlatform.config;
  };
  meta = {
    maintainers = with lib.maintainers; [ layus ];
    license = lib.licenses.mit;
  };
} ./auto-patchelf.sh
