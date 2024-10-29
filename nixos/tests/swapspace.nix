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
    };

    testScript = ''
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("swapspace.service")

      swamp = False
      with subtest("swapspace works"):
        for i in range(50):
          print(machine.succeed("df -h"))
          print(machine.succeed("free -h"))
          out = machine.succeed("swapon --show")
          swamp = "/swamp" in out
          print(out)
          if swamp:
            break

      print(machine.succeed("swapspace -e -s /swamp"))
      assert "/swamp" not in machine.execute("swapon --show")
      assert swamp
    '';
  }
)
