{
  callPackage,
  makeSetupHook,
  stdenv,
}:

makeSetupHook {
  name = "postgresql-test-hook";
  passthru.tests = {
    simple = callPackage ./test.nix { };
  };
  # See comment in postgresql's generic.nix doInstallCheck section.
  meta.broken = stdenv.hostPlatform.isDarwin;
} ./postgresql-test-hook.sh
