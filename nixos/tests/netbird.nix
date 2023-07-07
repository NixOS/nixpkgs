import ./make-test-python.nix ({ pkgs, lib, ... }:
{
  name = "netbird";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ misuzu ];
  };

  nodes = {
    node = { ... }: {
      services.netbird.enable = true;
    };
  };

  testScript = ''
    start_all()
    node.wait_for_unit("netbird.service")
    node.wait_for_file("/var/run/netbird/sock")
    node.succeed("netbird status | grep -q 'Daemon status: NeedsLogin'")
  '';
})
