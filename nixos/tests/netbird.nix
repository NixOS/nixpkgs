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

  # TODO: confirm the whole solution is working if/after netbird server is implemented
  testScript = ''
    start_all()
    node.wait_for_unit("netbird.service")
    node.wait_for_file("/var/run/netbird/sock")
    output = node.succeed("netbird status")
    assert "Disconnected" in output
  '';
})
