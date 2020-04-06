import ./make-test-python.nix ({ lib, pkgs, ... }:

let
  inherit (lib) mkMerge nameValuePair maintainers;

  baseGrafanaConf = {
    services.grafana = {
      enable = true;
      addr = "localhost";
      analytics.reporting.enable = false;
      domain = "localhost";
      security = {
        adminUser = "testadmin";
        adminPassword = "snakeoilpwd";
      };
    };
  };

  extraNodeConfs = {
    postgresql = {
      services.grafana.database = {
        host = "127.0.0.1:5432";
        user = "grafana";
      };
      services.postgresql = {
        enable = true;
        ensureDatabases = [ "grafana" ];
        ensureUsers = [{
          name = "grafana";
          ensurePermissions."DATABASE grafana" = "ALL PRIVILEGES";
        }];
      };
      systemd.services.grafana.after = [ "postgresql.service" ];
    };

    mysql = {
      services.grafana.database.user = "grafana";
      services.mysql = {
        enable = true;
        ensureDatabases = [ "grafana" ];
        ensureUsers = [{
          name = "grafana";
          ensurePermissions."grafana.*" = "ALL PRIVILEGES";
        }];
        package = pkgs.mariadb;
      };
      systemd.services.grafana.after = [ "mysql.service" ];
    };
  };

  nodes = builtins.listToAttrs (map (dbName:
    nameValuePair dbName (mkMerge [
    baseGrafanaConf
    (extraNodeConfs.${dbName} or {})
  ])) [ "sqlite" "postgresql" "mysql" ]);

in {
  name = "grafana";

  meta = with maintainers; {
    maintainers = [ willibutz ];
  };

  inherit nodes;

  testScript = ''
    start_all()

    with subtest("Successful API query as admin user with sqlite db"):
        sqlite.wait_for_unit("grafana.service")
        sqlite.wait_for_open_port(3000)
        sqlite.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/org/users | grep -q testadmin\@localhost"
        )
        sqlite.shutdown()

    with subtest("Successful API query as admin user with postgresql db"):
        postgresql.wait_for_unit("grafana.service")
        postgresql.wait_for_unit("postgresql.service")
        postgresql.wait_for_open_port(3000)
        postgresql.wait_for_open_port(5432)
        postgresql.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/org/users | grep -q testadmin\@localhost"
        )
        postgresql.shutdown()

    with subtest("Successful API query as admin user with mysql db"):
        mysql.wait_for_unit("grafana.service")
        mysql.wait_for_unit("mysql.service")
        mysql.wait_for_open_port(3000)
        mysql.wait_for_open_port(3306)
        mysql.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/org/users | grep -q testadmin\@localhost"
        )
        mysql.shutdown()
  '';
})
