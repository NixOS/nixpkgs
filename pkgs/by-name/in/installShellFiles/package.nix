{
  lib,
  callPackage,
  makeSetupHook,
}:

# See the header comment in ./setup-hook.sh for example usage.
makeSetupHook {
  name = "install-shell-files";
  passthru = {
    tests = lib.packagesFromDirectoryRecursive {
      inherit callPackage;
      directory = ./tests;
    };
  };
  meta.license = lib.licenses.mit;
} ./setup-hook.sh
