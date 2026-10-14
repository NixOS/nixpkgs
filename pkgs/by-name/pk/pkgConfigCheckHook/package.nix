{
  lib,
  makeSetupHook,
  buildPackages,
}:

makeSetupHook {
  name = "pkg-config-check-hook";

  propagatedNativeBuildInputs = [ buildPackages.pkg-config ];

  substitutions = {
    pkgconfig = lib.getExe buildPackages.pkg-config;
  };
} ./pkgConfigCheckHook.sh
