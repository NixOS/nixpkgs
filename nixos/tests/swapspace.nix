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
      # aarch64-linux on ofborg is 129M
      virtualisation.memorySize = 128;

      services.swapspace = {
        enable = true;
        extraArgs = [ "-v" ];
        settings = {
          # test outside /var/lib/swapspace
          swappath = "/swamp";
          cooldown = 1;
        };
      };

      swapDevices = lib.mkOverride 0 [
        {
          size = 127;
          device = "/root/swapfile";
        }
      ];
      boot.kernel.sysctl."vm.swappiness" = 30;
    };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("swapspace.service")
      machine.wait_for_unit("root-swapfile.swap")

      # sent usr1 and usr2 signals, kind of works outside but not in test
      print(machine.succeed("journalctl -b -u swapspace.service"))
      print(machine.succeed("swapon --show"))

      swamp = False
      with subtest("swapspace works"):
        machine.execute("mkdir /root/memfs")
        machine.execute("mount -o size=1G -t tmpfs none /root/memfs")
        for i in range(35):
          out = machine.succeed("swapon --show")
          swamp = "/swamp" in out
          print(out)
          if swamp:
            machine.succeed("rm -f /root/memfs/*")
            break
          machine.execute(f"dd if=/dev/zero of=/root/memfs/{i} bs=4238K count=1")

      print(machine.succeed("swapspace -e -s /swamp"))
      assert "/swamp" not in machine.execute("swapon --show")
      assert swamp
    '';
  }
)
