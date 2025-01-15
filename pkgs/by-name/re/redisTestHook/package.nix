{
  callPackage,
  makeSetupHook,
  redis,
}:

makeSetupHook {
  name = "redis-test-hook";
  substitutions = {
    cli = "${redis}/bin/redis-cli";
    server = "${redis}/bin/redis-server";
  };
  passthru.tests = {
    simple = callPackage ./test.nix { };
  };
} ./redis-test-hook.sh
