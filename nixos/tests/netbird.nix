import ./make-test-python.nix ({ pkgs, lib, ... }:
{
  name = "netbird";

  meta.maintainers = with pkgs.lib.maintainers; [ ];

  nodes = {
    node = { ... }: {
      services.netbird.enable = true;
    };
  };

  testScript = ''
    start_all()
    node.wait_for_unit("netbird-wt0.service")
    node.wait_for_file("/var/run/netbird/sock")
    node.succeed("netbird status | grep -q 'Daemon status: NeedsLogin'")
  '';
})
