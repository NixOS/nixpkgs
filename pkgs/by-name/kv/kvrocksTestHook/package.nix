{
  lib,
  callPackage,
  makeSetupHook,
  kvrocks,
  valkey,
}:

makeSetupHook {
  name = "kvrocks-test-hook";
  substitutions = {
    cli = lib.getExe' valkey "redis-cli";
    server = lib.getExe' kvrocks "kvrocks";
  };
  passthru.tests = {
    simple = callPackage ./test.nix { };
  };
} ./kvrocks-test-hook.sh
