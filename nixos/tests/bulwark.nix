{ pkgs, ... }:
{
  name = "bulwark";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      Cameo007
    ];
  };

  nodes.machine = {
    services.bulwark = {
      enable = true;
      settings.allowCustomJmapEndpoint = true;
    };
  };

  testScript = ''
    import json

    machine.wait_for_unit("bulwark")
    machine.wait_for_open_port(3000)

    status = machine.succeed("curl -f http://localhost:3000/api/health")
    assert json.loads(status)["status"] == "healthy", "The fetched config does not match"

    machine.wait_until_succeeds("journalctl -u bulwark | grep -q 'scheduler not started'")
    machine.fail("journalctl -u bulwark | grep -q 'init skipped'")
  '';
}
