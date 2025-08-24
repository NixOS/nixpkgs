{ lib, ... }:

{
  name = "pocket-id";
  meta.maintainers = with lib.maintainers; [
    gepbird
    ymstnt
  ];

  nodes = {
    machineSqlite =
      { ... }:
      {
        services.pocket-id = {
          enable = true;
          settings = {
            PORT = 10001;
          };
        };
      };

    machinePostgres =
      { config, ... }:
      let
        username = config.services.pocket-id.user;
      in
      {
        services.pocket-id = {
          enable = true;
          settings = {
            PORT = 10001;
            DB_PROVIDER = "postgres";
            DB_CONNECTION_STRING = "host=/run/postgresql user=${username} database=${username}";
          };
        };

        services.postgresql = {
          enable = true;
          ensureUsers = [
            {
              name = "${username}";
              ensureDBOwnership = true;
            }
          ];
          ensureDatabases = [ "${username}" ];
        };
      };
  };

  testScript =
    { nodes, ... }:
    let
      settingsSqlite = nodes.machineSqlite.services.pocket-id.settings;
      settingsPostgres = nodes.machinePostgres.services.pocket-id.settings;
      inherit (builtins) toString;
    in
    ''
      machineSqlite.wait_for_unit("pocket-id.service")
      machineSqlite.wait_for_open_port(${toString settingsSqlite.PORT})

      backend_status = machineSqlite.succeed("curl -L -o /tmp/backend-output -w '%{http_code}' http://localhost:${toString settingsSqlite.PORT}/api/users/me")
      assert backend_status == "401"
      machineSqlite.succeed("grep 'You are not signed in' /tmp/backend-output")

      frontend_status = machineSqlite.succeed("curl -L -o /tmp/frontend-output -w '%{http_code}' http://localhost:${toString settingsSqlite.PORT}")
      assert frontend_status == "200"


      machinePostgres.wait_for_unit("pocket-id.service")
      machinePostgres.wait_for_open_port(${toString settingsPostgres.PORT})

      backend_status = machinePostgres.succeed("curl -L -o /tmp/backend-output -w '%{http_code}' http://localhost:${toString settingsPostgres.PORT}/api/users/me")
      assert backend_status == "401"
      machinePostgres.succeed("grep 'You are not signed in' /tmp/backend-output")

      frontend_status = machinePostgres.succeed("curl -L -o /tmp/frontend-output -w '%{http_code}' http://localhost:${toString settingsPostgres.PORT}")
      assert frontend_status == "200"
    '';
}
