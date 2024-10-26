import ./make-test-python.nix (
  { pkgs, lib, ... }:

  {
    name = "swapspace";

    meta = with pkgs.lib.maintainers; {
      maintainers = [
        Luflosi
        phanirithvij
      ];
    };

    nodes.machine = {
      virtualisation.memorySize = 256;
      systemd.oomd.extraConfig.DefaultMemoryPressureDurationSec = "1s";

      services.swapspace = {
        enable = true;
        extraArgs = [ "-v" ];
        settings = {
          # test outside /var/lib/swapspace
          swappath = "/root/swamp";
          cooldown = 1;
        };
      };

      swapDevices = lib.mkOverride 0 [
        {
          device = "/root/swapfile";
          size = 128;
        }
      ];

      # adopted from systemd-oomd test
      systemd.slices.workload = {
        description = "Test slice for memory pressure kills";
        sliceConfig = {
          MemoryAccounting = true;
          ManagedOOMMemoryPressure = "kill";
          ManagedOOMMemoryPressureLimit = "70%";
        };
      };

      systemd.services.testbloat = {
        description = "Create a lot of memory pressure";
        serviceConfig = {
          Slice = "workload.slice";
          MemoryHigh = "128M";
          ExecStart = "${pkgs.coreutils}/bin/tail /dev/zero";
        };
      };
    };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("swapspace.service")
      machine.wait_for_unit("root-swapfile.swap")

      print(machine.succeed("systemctl status swapspace.service"))
      print(machine.succeed("swapon --show"))

      swamp = False
      with subtest("swapspace works and oom is a safeguard"):
        machine.succeed("systemctl start testbloat.service")
        # wait for a maximum of 45sec
        for i in range(1, 11):
          print(machine.succeed("free -h"))
          out = machine.succeed("swapon --show")
          swamp = "/root/swamp" in out
          print(out)
          if swamp:
            machine.succeed("systemctl kill --wait testbloat.service")
            break
          machine.sleep(i)

      print(machine.succeed("swapspace -e -s /root/swamp"))
      machine.succeed("swapoff /root/swapfile")
      assert machine.succeed("swapon --show") == ""
      assert swamp
    '';
  }
)
