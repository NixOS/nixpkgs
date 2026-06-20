import ./make-test-python.nix (
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
        services.postgresql = {
          enable = true;
          initialScript = pkgs.writeText "init.sql" ''
            CREATE USER ${config.services.oxibooru.database.user} WITH PASSWORD '${dbpass}';
            CREATE DATABASE ${config.services.oxibooru.database.name} WITH OWNER ${config.services.oxibooru.database.user};
          '';
        };

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
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("oxibooru.service")
      machine.wait_for_open_port(7777)
      machine.succeed('curl -H "Content-Type: application/json" -H "Accept: application/json" --fail http://127.0.0.1:7777/info')
    '';
  }
)
