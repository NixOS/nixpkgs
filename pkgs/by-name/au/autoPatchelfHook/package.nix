{
  stdenv,
  makeSetupHook,
  auto-patchelf,
  bintools,
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
} ./hook.sh
