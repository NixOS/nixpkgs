import ./make-test.nix ({ lib, pkgs, ... }:

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
    startAll();

    subtest "Grafana sqlite", sub {
      $sqlite->waitForUnit("grafana.service");
      $sqlite->waitForOpenPort(3000);
      $sqlite->succeed("curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/org/users | grep -q testadmin\@localhost");
    };

    subtest "Grafana postgresql", sub {
      $postgresql->waitForUnit("grafana.service");
      $postgresql->waitForUnit("postgresql.service");
      $postgresql->waitForOpenPort(3000);
      $postgresql->waitForOpenPort(5432);
      $postgresql->succeed("curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/org/users | grep -q testadmin\@localhost");
    };

    subtest "Grafana mysql", sub {
      $mysql->waitForUnit("grafana.service");
      $mysql->waitForUnit("mysql.service");
      $mysql->waitForOpenPort(3000);
      $mysql->waitForOpenPort(3306);
      $mysql->succeed("curl -sSfN -u testadmin:snakeoilpwd http://127.0.0.1:3000/api/org/users | grep -q testadmin\@localhost");
    };
  '';
})
