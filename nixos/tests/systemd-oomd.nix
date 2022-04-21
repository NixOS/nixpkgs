import ./make-test-python.nix ({ pkgs, ... }:

{
  name = "systemd-oomd";

  nodes.machine = { pkgs, ... }: {
    systemd.oomd.extraConfig.DefaultMemoryPressureDurationSec = "1s"; # makes the test faster
    # Kill cgroups when more than 1% pressure is encountered
    systemd.slices."-".sliceConfig = {
      ManagedOOMMemoryPressure = "kill";
      ManagedOOMMemoryPressureLimit = "1%";
    };
    # A service to bring the system under memory pressure
    systemd.services.testservice = {
      serviceConfig.ExecStart = "${pkgs.coreutils}/bin/tail /dev/zero";
    };
    # Do not kill the backdoor
    systemd.services.backdoor.serviceConfig.ManagedOOMMemoryPressure = "auto";

    virtualisation.memorySize = 1024;
  };

  testScript = ''
    # Start the system
    machine.wait_for_unit("multi-user.target")
    machine.succeed("oomctl")

    # Bring the system into memory pressure
    machine.succeed("echo 0 > /proc/sys/vm/panic_on_oom")  # NixOS tests kill the VM when the OOM killer is invoked - override this
    machine.succeed("systemctl start testservice")

    # Wait for oomd to kill something
    # Matches these lines:
    # systemd-oomd[508]: Killed /system.slice/systemd-udevd.service due to memory pressure for / being 3.26% > 1.00% for > 1s with reclaim activity
    machine.wait_until_succeeds("journalctl -b | grep -q 'due to memory pressure for'")
  '';
})
