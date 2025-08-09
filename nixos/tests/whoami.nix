{ lib, ... }:

{
  name = "echoip";
  meta.maintainers = with lib.maintainers; [ defelo ];

  nodes.machine = {
    services.whoami.enable = true;
  };

  interactive.nodes.machine = {
    networking.firewall.allowedTCPPorts = [ 8000 ];
    virtualisation.forwardPorts = [
      {
        from = "host";
        host.port = 8000;
        guest.port = 8000;
      }
    ];
  };

  testScript = ''
    import re

    machine.wait_for_unit("whoami.service")
    machine.wait_for_open_port(8000)

    response = machine.succeed("curl -H 'X-Test-Header: Hello World!' http://127.0.0.1:8000/test")
    assert re.search(r"^GET /test", response, re.M)
    assert re.search(r"^X-Test-Header: Hello World!", response, re.M)
  '';
}
