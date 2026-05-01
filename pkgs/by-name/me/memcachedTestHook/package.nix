{
  callPackage,
  makeSetupHook,
  lib,
  memcached,
  netcat,
}:

makeSetupHook {
  name = "memcached-test-hook";
  substitutions = {
    memcached = lib.getExe memcached;
    nc = lib.getExe netcat;
  };
  passthru.tests = {
    simple = callPackage ./test.nix { };
  };
} ./memcached-test-hook.sh
