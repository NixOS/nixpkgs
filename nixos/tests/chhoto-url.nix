{ config, lib, ... }:

{
  name = "chhoto-url";
  meta.maintainers = with lib.maintainers; [ defelo ];

  nodes.machine = {
    services.chhoto-url = {
      enable = true;
      settings.port = 8000;
      environmentFiles = [
        (builtins.toFile "chhoto-url.env" ''
          api_key=api_key
          password=password
        '')
      ];
    };
  };

  interactive.nodes.machine = {
    services.glitchtip.listenAddress = "0.0.0.0";
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
    import re

    machine.wait_for_unit("chhoto-url.service")
    machine.wait_for_open_port(8000)

    resp = json.loads(machine.succeed("curl localhost:8000/api/getconfig"))
    assert resp["success"] is False
    assert resp["reason"] == "No valid authentication was found"

    resp = json.loads(machine.succeed("curl -H 'X-API-Key: api_key' localhost:8000/api/getconfig"))
    expected_version = "${config.nodes.machine.services.chhoto-url.package.version}"
    assert resp["version"] == expected_version

    resp = json.loads(machine.succeed("curl -H 'X-API-Key: api_key' localhost:8000/api/new -d '{\"longlink\": \"https://nixos.org/\"}'"))
    assert resp["success"] is True
    assert (match := re.match(r"^http://localhost:8000/(.+)$", resp["shorturl"]))
    slug = match[1]

    resp = machine.succeed(f"curl -i {resp["shorturl"]}")
    assert (match := re.search(r"(?m)^location: (.+?)\r?$", resp))
    assert match[1] == "https://nixos.org/"

    resp = json.loads(machine.succeed(f"curl -H 'X-API-Key: api_key' localhost:8000/api/expand -d '{slug}'"))
    assert resp["success"] is True
    assert resp["hits"] == 1
  '';
}
