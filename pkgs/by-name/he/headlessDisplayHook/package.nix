{
  lib,
  stdenv,
  makeSetupHook,
  xvfb,
  makeFontsConf,
  dejavu_fonts,
  mesa,
}:
if stdenv.hostPlatform.isLinux then
  makeSetupHook {
    name = "headlessDisplayHook";
    propagatedBuildInputs = [
      xvfb
      mesa.llvmpipeHook
    ];
    substitutions = {
      fontconfig_file = makeFontsConf { fontDirectories = [ dejavu_fonts ]; };
      ld_library_path = lib.makeLibraryPath [ mesa ];
    };
  } ./headless-display-hook.sh
else
  null
