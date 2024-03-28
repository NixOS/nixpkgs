import ./make-test-python.nix ({ pkgs, lib, ... }:
{
  name = "vpp";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ raitobezarius ];
  };

  nodes = {
    node = { ... }: {
      # Clearly, VPP is hungry of hugepages…
      virtualisation.memorySize = 4096;
      services.vpp = {
        enable = true;
        configFile = pkgs.writeText "startup.conf" ''
          unix {
            nodaemon
            nosyslog
            full-coredump
            cli-listen /run/vpp/cli.sock
          }

          api-trace {
            on
          }
        '';
      };
    };
  };

  testScript = ''
    start_all()
    node.wait_for_unit("multi-user.target")
    node.wait_for_unit("vpp.service")
    node.succeed("vppctl show version | grep -i nixos")
    node.succeed("vppctl show interface | grep -i local0")
  '';
})
