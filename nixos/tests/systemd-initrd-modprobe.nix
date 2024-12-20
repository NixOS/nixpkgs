import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "systemd-initrd-modprobe";

    nodes.machine =
      { pkgs, ... }:
      {
        testing.initrdBackdoor = true;
        boot.initrd.systemd.enable = true;
        boot.initrd.kernelModules = [ "tcp_hybla" ]; # Load module in initrd.
        boot.extraModprobeConfig = ''
          options tcp_hybla rtt0=42
        '';
      };

    testScript = ''
      machine.wait_for_unit("initrd.target")
      rtt = machine.succeed("cat /sys/module/tcp_hybla/parameters/rtt0")
      assert int(rtt) == 42, "Parameter should be respected for initrd kernel modules"

      # Make sure it sticks in stage 2
      machine.switch_root()
      machine.wait_for_unit("multi-user.target")
      rtt = machine.succeed("cat /sys/module/tcp_hybla/parameters/rtt0")
      assert int(rtt) == 42, "Parameter should be respected for initrd kernel modules"
    '';
  }
)
