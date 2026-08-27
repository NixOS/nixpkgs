{ pkgs, lib, ... }:
{
  name = "technitium-dns-server";

  nodes = {
    machine =
      { pkgs, ... }:
      {
        systemd.services.technitium-dns-server.serviceConfig.Restart = lib.mkForce "no";

        services.technitium-dns-server = {
          enable = true;
          openFirewall = true;
        };
      };
  };

  testScript = ''
    import json

    start_all()
    machine.wait_for_unit("technitium-dns-server.service")
    machine.wait_for_open_port(53)
    curl_cmd = 'curl --fail-with-body -X GET "http://localhost:5380/api/user/login?user=admin&pass=admin"'
    output = json.loads(machine.wait_until_succeeds(curl_cmd, timeout=10))
    print(output)
    assert "ok" == output['status'], "status not ok"
  '';

  meta.maintainers = with lib.maintainers; [ fabianrig ];
}
