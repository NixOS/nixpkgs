{ lib, ... }:
let
  port = 3001;
  host = "karakeep_server";
in
{
  name = "karakeep";
  meta.maintainers = with lib.maintainers; [ tetov ];

  nodes.${host} = {
    networking.firewall.allowedTCPPorts = [ port ];

    services.karakeep = {
      enable = true;
      extraEnvironment = {
        HOST = host;
        PORT = toString port;
        DISABLE_NEW_RELEASE_CHECK = "true";
      };
      meilisearch.enable = true;
    };
  };

  testScript = ''
    import json

    ${host}.wait_for_unit("karakeep-web")

    resp = json.loads(${host}.wait_until_succeeds("curl -sS -f http://${host}:${toString port}/api/health", timeout=300))

    assert resp["status"] == "ok"
  '';
}
