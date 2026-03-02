{
  callPackage,
  makeSetupHook,
  lib,
}:

makeSetupHook {
  name = "postgresql-test-hook";
  passthru.tests = {
    simple = callPackage ./test.nix { };
  };
  # See comment in postgresql's generic.nix doInstallCheck section.
  meta.badPlatforms = lib.platforms.darwin;
} ./postgresql-test-hook.sh
