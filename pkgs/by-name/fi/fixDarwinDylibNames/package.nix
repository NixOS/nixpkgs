{
  lib,
  darwin,
  makeSetupHook,
}:

makeSetupHook {
  name = "fix-darwin-dylib-names-hook";
  substitutions = {
    inherit (darwin.binutils) targetPrefix;
  };
  meta.platforms = lib.platforms.darwin;
} ./hook.sh
