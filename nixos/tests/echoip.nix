{ lib, ... }:

{
  name = "echoip";
  meta.maintainers = with lib.maintainers; [ defelo ];

  nodes.machine = {
    services.echoip = {
      enable = true;
      virtualHost = "echoip.local";
    };

    networking.hosts = {
      "127.0.0.1" = [ "echoip.local" ];
      "::1" = [ "echoip.local" ];
    };
  };

  testScript = ''
    machine.wait_for_unit("echoip.service")
    machine.wait_for_open_port(8080)

    resp = machine.succeed("curl -4 http://echoip.local/ip")
    assert resp.strip() == "127.0.0.1"
    resp = machine.succeed("curl -6 http://echoip.local/ip")
    assert resp.strip() == "::1"
  '';
}
