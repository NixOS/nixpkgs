{
  lib,
  callPackage,
  makeSetupHook,
  hunk,
  worktrunk,
  gh-stack,
}:

# used installFonts, installShellFiles as reference
# See the header comment in ./setup-hook.sh for example usage.
makeSetupHook {
  name = "install-agent-skills";
  passthru = {
    tests =
      lib.packagesFromDirectoryRecursive {
        inherit callPackage;
        directory = ./tests;
      }
      // {
        # few consumers that are good to test
        inherit worktrunk hunk gh-stack;
      };
  };
  meta = {
    description = "Tools to install Agent skills into the correct directories";
    license = lib.licenses.mit;
  };
} ./setup-hook.sh
