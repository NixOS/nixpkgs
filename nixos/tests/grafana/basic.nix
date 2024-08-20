import ../make-test-python.nix ({ lib, pkgs, ... }:

let
  inherit (lib) mkMerge nameValuePair maintainers;

  baseGrafanaConf = {
    services.grafana = {
      enable = true;
      settings = {
        analytics.reporting_enabled = false;

        server = {
          http_addr = "::1";
          domain = "localhost";
        };

        security = {
          admin_user = "testadmin";
          admin_password = "snakeoilpwd";
        };
      };
    };
  };

  extraNodeConfs = {
    sqlite = {};

    socket = { config, ... }: {
      services.grafana.settings.server = {
        protocol = "socket";
        socket = "/run/grafana/sock";
        socket_gid = config.users.groups.nginx.gid;
      };

      users.users.grafana.extraGroups = [ "nginx" ];

      services.nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts."_".locations."/".proxyPass = "http://unix:/run/grafana/sock";
      };
    };

    declarativePlugins = {
      services.grafana.declarativePlugins = [ pkgs.grafanaPlugins.grafana-clock-panel ];
    };

    postgresql = {
      services.grafana.settings.database = {
        host = "[::1]:5432";
        user = "grafana";
      };
      services.postgresql = {
        enable = true;
        ensureDatabases = [ "grafana" ];
        ensureUsers = [{
          name = "grafana";
          ensureDBOwnership = true;
        }];
      };
      systemd.services.grafana.after = [ "postgresql.service" ];
    };

    mysql = {
      services.grafana.settings.database.user = "grafana";
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

  nodes = builtins.mapAttrs (_: val: mkMerge [ val baseGrafanaConf ]) extraNodeConfs;
in {
  name = "grafana-basic";

  meta = with maintainers; {
    maintainers = [ willibutz ];
  };

  inherit nodes;

  testScript = ''
    start_all()

    with subtest("Declarative plugins installed"):
        declarativePlugins.wait_for_unit("grafana.service")
        declarativePlugins.wait_for_open_port(3000, addr="::1")
        declarativePlugins.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://[::1]:3000/api/plugins | grep grafana-clock-panel"
        )
        declarativePlugins.shutdown()

    with subtest("Successful API query as admin user with sqlite db"):
        sqlite.wait_for_unit("grafana.service")
        sqlite.wait_for_open_port(3000)
        print(sqlite.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://[::1]:3000/api/org/users -i"
        ))
        sqlite.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://[::1]:3000/api/org/users | grep admin\@localhost"
        )
        sqlite.shutdown()

    with subtest("Successful API query as admin user with sqlite db listening on socket"):
        socket.wait_for_unit("grafana.service")
        socket.wait_for_open_port(80)
        print(socket.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://[::1]/api/org/users -i"
        ))
        socket.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://[::1]/api/org/users | grep admin\@localhost"
        )
        socket.shutdown()

    with subtest("Successful API query as admin user with postgresql db"):
        postgresql.wait_for_unit("grafana.service")
        postgresql.wait_for_unit("postgresql.service")
        postgresql.wait_for_open_port(3000)
        postgresql.wait_for_open_port(5432)
        postgresql.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://[::1]:3000/api/org/users | grep admin\@localhost"
        )
        postgresql.shutdown()

    with subtest("Successful API query as admin user with mysql db"):
        mysql.wait_for_unit("grafana.service")
        mysql.wait_for_unit("mysql.service")
        mysql.wait_for_open_port(3000)
        mysql.wait_for_open_port(3306)
        mysql.succeed(
            "curl -sSfN -u testadmin:snakeoilpwd http://[::1]:3000/api/org/users | grep admin\@localhost"
        )
        mysql.shutdown()
  '';
})
