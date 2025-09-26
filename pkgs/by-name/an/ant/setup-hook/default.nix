{ makeSetupHook, callPackage }:
makeSetupHook {
  name = "ant-setup-hook";
  passthru.tests = {
    findExternalAntTasks = callPackage ./test-findExternalAntTasks.nix { };
  };
} ./setup-hook.sh
