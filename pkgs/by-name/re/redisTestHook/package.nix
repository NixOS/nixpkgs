{
  lib,
  callPackage,
  makeSetupHook,
  valkey,
  python3Packages,
}:

makeSetupHook {
  name = "redis-test-hook";
  substitutions = {
    cli = lib.getExe' valkey "redis-cli";
    server = lib.getExe' valkey "redis-server";
  };
  passthru.tests = {
    simple = callPackage ./test.nix { };
    python3-valkey = python3Packages.valkey;
  };
} ./redis-test-hook.sh
