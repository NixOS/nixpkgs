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
  meta = {
    # See comment in postgresql's generic.nix doInstallCheck section.
    badPlatforms = lib.platforms.darwin;
    license = lib.licenses.mit;
  };
} ./postgresql-test-hook.sh
