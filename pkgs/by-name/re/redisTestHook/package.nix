{
  lib,
  callPackage,
  makeSetupHook,
  redis,
}:

makeSetupHook {
  name = "redis-test-hook";
  substitutions = {
    cli = lib.getExe' redis "redis-cli";
    server = lib.getExe' redis "redis-server";
  };
  passthru.tests = {
    simple = callPackage ./test.nix { };
  };
} ./redis-test-hook.sh
