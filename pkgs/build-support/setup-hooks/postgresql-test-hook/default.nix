{ callPackage, makeSetupHook }:

(makeSetupHook {
  name = "postgresql-test-hook";
} ./postgresql-test-hook.sh).overrideAttrs (o: {
  passthru.tests = {
    simple = callPackage ./test.nix { };
  };
})
