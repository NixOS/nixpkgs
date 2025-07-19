{
  lib,
  stdenv,
  makeSetupHook,
}:

makeSetupHook {
  name = "fix-darwin-dylib-names-hook";
  substitutions = {
    inherit (stdenv.cc) targetPrefix;
  };
  meta.platforms = lib.platforms.darwin;
} ./hook.sh
