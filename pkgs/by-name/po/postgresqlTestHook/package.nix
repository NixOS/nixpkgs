{
  lib,
  callPackage,
  makeSetupHook,
  postgresql,
}:

makeSetupHook {
  name = "postgresql-test-hook";
  propagatedBuildInputs = [ postgresql ];
  passthru.tests = {
    simple = callPackage ./test.nix { };
  };
} ./postgresql-test-hook.sh
