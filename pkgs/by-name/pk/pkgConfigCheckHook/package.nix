{
  lib,
  makeSetupHook,
  pkg-config,
}:

makeSetupHook {
  name = "pkg-config-check-hook";

  propagatedNativeBuildInputs = [ pkg-config ];

  substitutions = {
    pkgconfig = lib.getExe pkg-config;
  };
} ./pkgConfigCheckHook.sh
