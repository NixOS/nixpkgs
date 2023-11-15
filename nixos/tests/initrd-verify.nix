import ./make-test-python.nix ({ ... }: {
  name = "initrd-verify";

  nodes.machine = {
    boot.initrd.systemd.enable = true;
    boot.initrd.verify = {
      enable = true;
      trustedPublicKeys = [(builtins.readFile ./initrd-verify.pub)];
      signing = {
        enable = true;
        keyFile = "${./initrd-verify.secret}";
      };
    };

    # We want to detect failure in stage 1 ourselves.
    testing.initrdBackdoor = true;
    boot.initrd.systemd.services.panic-on-fail.enable = false;

    virtualisation.useBootLoader = true;
    virtualisation.useEFIBoot = true;
    boot.loader.timeout = 0;
    boot.loader.systemd-boot.enable = true;
  };

  testScript = ''
    machine.switch_root()
    machine.wait_for_unit("multi-user.target")
    machine.succeed(
        "mount -o remount,rw /nix/store",
        # Invalidate a dependency (systemd) to verify recursion
        "echo invalidate > /run/current-system/systemd/invalidated",
        "sync",
    )
    machine.shutdown()
    machine.start()
    def check_failed(_) -> bool:
        info = machine.get_unit_info("verify-store.service")
        state = info["ActiveState"]
        if state == "failed":
            return True
        else:
            status, jobs = machine.systemctl("list-jobs --full 2>&1")
            if "No jobs" in jobs:
                raise Exception('verify-store.service never failed as it should have.')
            else:
                return False
    with machine.nested("Waiting for verification to fail"):
        retry(check_failed)
  '';
})
