{ callPackage, makeSetupHook }:

makeSetupHook {
  name = "mysql-test-hook";
  passthru.tests = {
    simple = callPackage ./test.nix { };
  };
} ./mysql-test-hook.sh
