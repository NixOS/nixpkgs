{ callPackage, makeSetupHook }:

(makeSetupHook {
  name = "postgresql-test-hook";
  passthru.tests = {
    simple = callPackage ./test.nix { };
  };
} ./postgresql-test-hook.sh).overrideAttrs
  # For shared memory on Darwin.
  {
    propagatedSandboxProfile = ''
      (allow ipc-sysv-shm)
      (allow ipc-sysv-sem)
    '';
  }
