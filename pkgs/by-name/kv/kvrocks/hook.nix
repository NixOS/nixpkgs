{
  lib,
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
} ./hook.sh
