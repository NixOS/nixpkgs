{
  lib,
  stdenv,
  makeSetupHook,
  weston,
  fontconfig,
  mesa,
}:
if stdenv.hostPlatform.isLinux then
  makeSetupHook {
    name = "headlessDisplayHook";
    propagatedBuildInputs = [
      weston
      mesa.llvmpipeHook
    ];
    substitutions = {
      fontconfig_file = "${fontconfig.out}/etc/fonts/fonts.conf";
      ld_library_path = lib.makeLibraryPath [ mesa ];
    };
  } ./headless-display-hook.sh
else
  null
