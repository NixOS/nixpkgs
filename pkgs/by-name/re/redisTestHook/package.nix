{
  lib,
  callPackage,
  makeSetupHook,
  valkey,
}:

makeSetupHook {
  name = "redis-test-hook";
  substitutions = {
    cli = lib.getExe' valkey "redis-cli";
    server = lib.getExe' valkey "redis-server";
  };
  passthru.tests = {
    simple = callPackage ./test.nix { };
  };
} ./redis-test-hook.sh
