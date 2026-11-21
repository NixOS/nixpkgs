{ lib, pkgs, ... }:
{
  name = "oxibooru";
  meta.maintainers = with lib.maintainers; [ ratcornu ];

  nodes.machine =
    let
      dbpass = "changeme";
    in

    { config, ... }:
    {
      services.postgresql.enable = true;

      services.oxibooru = {
        enable = true;

        dataDir = "/var/lib/oxibooru";

        server = {
          port = 7777;
          settings = {
            domain = "http://127.0.0.1";
            secretFile = pkgs.writeText "secret" "secret";
          };
        };

        database = {
          host = "localhost";
          port = 5432;
          name = "oxibooru";
          user = "oxibooru";
          passwordFile = pkgs.writeText "pass" "${dbpass}";
          createLocally = true;
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("oxibooru.service")
    machine.wait_for_open_port(7777)
    machine.succeed('curl -H "Content-Type: application/json" -H "Accept: application/json" --fail http://127.0.0.1:7777/info')
  '';
}
