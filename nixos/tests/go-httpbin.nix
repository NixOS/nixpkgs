{ lib, ... }:

{
  name = "go-httpbin";
  meta.maintainers = with lib.maintainers; [ defelo ];

  nodes.machine = {
    services.go-httpbin = {
      enable = true;
      settings.PORT = 8000;
    };
  };

  interactive.nodes.machine = {
    services.go-httpbin.settings.HOST = "0.0.0.0";
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
    import json

    machine.wait_for_unit("go-httpbin.service")
    machine.wait_for_open_port(8000)

    resp = json.loads(machine.succeed("curl localhost:8000/get?foo=bar"))
    assert resp["args"]["foo"] == ["bar"]
    assert resp["method"] == "GET"
    assert resp["origin"] == "127.0.0.1"
    assert resp["url"] == "http://localhost:8000/get?foo=bar"
  '';
}
