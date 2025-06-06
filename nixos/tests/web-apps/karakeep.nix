{ lib, ... }:
let
  port = 3001;
  host = "karakeep_server";
in
{
  name = "karakeep";
  meta.maintainers = with lib.maintainers; [ tetov ];

  nodes = {
    ${host} =
      { config, pkgs, ... }:
      {
        networking.firewall.allowedTCPPorts = [ port ];

        services.karakeep = {
          enable = true;
          extraEnvironment = {
            HOST = host;
            PORT = toString port;
          };
        };
      };
    client = { };
  };

  testScript = ''
    import json

    ${host}.wait_for_unit("karakeep-web")
    client.wait_for_unit("default.target")

    resp = json.loads(client.wait_until_succeeds("curl -sS -f http://${host}:${toString port}/api/health", timeout=300))

    assert resp["status"] == "ok"
  '';
}
