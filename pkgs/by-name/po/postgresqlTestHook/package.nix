{ callPackage, makeSetupHook }:

makeSetupHook {
  name = "postgresql-test-hook";
  passthru.tests = {
    simple = callPackage ./test.nix { };
  };
} ./postgresql-test-hook.sh
