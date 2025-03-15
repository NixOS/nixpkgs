{
  lib,
  callPackage,
  makeSetupHook,
  postgresql,
}:

makeSetupHook {
  name = "postgresql-test-hook";
  substitutions = {
    inherit postgresql;
    # for pg_config
    postgresqlDev = lib.getDev postgresql;
  };
  passthru.tests = {
    simple = callPackage ./test.nix { };
  };
} ./postgresql-test-hook.sh
