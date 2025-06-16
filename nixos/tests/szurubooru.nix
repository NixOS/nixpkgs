import ./make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "szurubooru";
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
            CREATE USER ${config.services.szurubooru.database.user} WITH PASSWORD '${dbpass}';
            CREATE DATABASE ${config.services.szurubooru.database.name} WITH OWNER ${config.services.szurubooru.database.user};
          '';
        };

        services.szurubooru = {
          enable = true;

          dataDir = "/var/lib/szurubooru";

          server = {
            port = 6666;
            settings = {
              domain = "http://127.0.0.1";
              secretFile = pkgs.writeText "secret" "secret";
              debug = 1;
            };
          };

          database = {
            host = "localhost";
            port = 5432;
            name = "szurubooru";
            user = "szurubooru";
            passwordFile = pkgs.writeText "pass" "${dbpass}";
          };
        };
      };

    testScript = ''
      machine.wait_for_unit("szurubooru.service")
      machine.wait_for_open_port(6666)
      machine.succeed('curl -H "Content-Type: application/json" -H "Accept: application/json" --fail http://127.0.0.1:6666/info')
    '';
  }
)
