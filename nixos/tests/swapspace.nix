import ./make-test-python.nix (
  { lib, ... }:

  {
    name = "swapspace";

    meta = with lib.maintainers; {
      maintainers = [
        Luflosi
        phanirithvij
      ];
    };

    nodes.machine = {
      virtualisation.memorySize = 512;

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
      boot.kernel.sysctl."vm.swappiness" = 60;
    };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("swapspace.service")
      machine.wait_for_unit("root-swapfile.swap")

      # ensure swapspace wrapper command runs
      machine.succeed("swapspace --inspect")

      swamp = False
      with subtest("swapspace works"):
        machine.execute("mkdir /root/memfs")
        machine.execute("mount -o size=2G -t tmpfs none /root/memfs")
        i = 0
        while i < 14:
          print(machine.succeed("free -h"))
          out = machine.succeed("sh -c 'swapon --show --noheadings --raw --bytes | grep /root/swapfile'")
          row = out.split(' ')
          # leave 1MB free to not get killed by oom
          freebytes=int(row[2]) - int(row[3]) - 1*1024*1024
          machine.succeed(f"dd if=/dev/random of=/root/memfs/{i} bs={freebytes} count=1")
          machine.sleep(1)
          out = machine.succeed("swapon --show")
          print(out)
          swamp = "/swamp" in out
          if not swamp:
            i += 1
          else:
            print("*"*10, "SWAPED", "*"*10)
            machine.succeed("rm -f /root/memfs/*")
            break

      print(machine.succeed("swapspace -e -s /swamp"))
      assert "/swamp" not in machine.execute("swapon --show")
      assert swamp
    '';
  }
)
