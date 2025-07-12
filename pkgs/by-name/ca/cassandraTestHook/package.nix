{
  callPackage,
  makeSetupHook,
  stdenv,
}:

makeSetupHook {
  name = "cassandra-test-hook";
  passthru.tests = {
    simple = callPackage ./test.nix { };
  };
  meta.broken = stdenv.hostPlatform.isDarwin;
} ./cassandra-test-hook.sh
