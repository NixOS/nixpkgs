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
    memcached = memcached.exe;
    nc = netcat.exe;
  };
  passthru.tests = {
    simple = callPackage ./test.nix { };
  };
} ./memcached-test-hook.sh
