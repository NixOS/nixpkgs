{ config, lib, ... }:

{
  name = "chhoto-url";
  meta.maintainers = with lib.maintainers; [ defelo ];

  defaults.services.chhoto-url = {
    enable = true;
    settings.port = 8000;
    environmentFiles = [
      (builtins.toFile "chhoto-url.env" ''
        api_key=api_key
        password=password
      '')
    ];
  };

  nodes.machine = {
    services.chhoto-url.settings.CHHOTO_HEALTH_PORT = 1729;
  };

  # The health check endpoint is disabled by default.
  nodes.nohealth = { };

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

  interactive.sshBackdoor.enable = true;
  interactive.defaults.virtualisation.graphics = false;

  testScript = ''
    import json
    import re
    import time

    start_all()

    nohealth.wait_for_unit("chhoto-url.service")
    nohealth.wait_for_open_port(8000)
    nohealth.succeed("curl --fail localhost:8000/")
    nohealth.fail("curl localhost:1729/healthz")

    machine.wait_for_unit("chhoto-url.service")
    machine.wait_for_open_port(8000)
    machine.wait_for_open_port(1729)

    machine.succeed("curl --fail localhost:1729/healthz")

    resp = json.loads(machine.succeed("curl localhost:8000/api/getconfig"))
    assert resp["success"] is False
    assert resp["reason"] == "No valid authentication."

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

    time.sleep(2)
    resp = json.loads(machine.succeed(f"curl -H 'X-API-Key: api_key' localhost:8000/api/expand -d '{slug}'"))
    assert resp["success"] is True
    assert resp["longurl"] == "https://nixos.org/"
    assert resp["hits"] == 1
  '';
}
