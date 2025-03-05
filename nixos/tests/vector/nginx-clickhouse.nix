import ../make-test-python.nix ({ lib, pkgs, ... }:

{
  name = "vector-nginx-clickhouse";
  meta.maintainers = [ pkgs.lib.maintainers.happysalada ];

  nodes = {
    clickhouse = { config, pkgs, ... }: {
      virtualisation.memorySize = 4096;

      # Clickhouse module can't listen on a non-loopback IP.
      networking.firewall.allowedTCPPorts = [ 6000 ];
      services.clickhouse.enable = true;

      # Exercise Vector sink->source for now.
      services.vector = {
        enable = true;

        settings = {
          sources = {
            vector_source = {
              type = "vector";
              address = "[::]:6000";
            };
          };

          sinks = {
            clickhouse = {
              type = "clickhouse";
              inputs = [ "vector_source" ];
              endpoint = "http://localhost:8123";
              database = "nginxdb";
              table = "access_logs";
              skip_unknown_fields = true;
            };
          };
        };
      };
    };

    nginx = { config, pkgs, ... }: {
      services.nginx = {
        enable = true;
        virtualHosts.localhost = {};
      };

      services.vector = {
        enable = true;

        settings = {
          sources = {
            nginx_logs = {
              type = "file";
              include = [ "/var/log/nginx/access.log" ];
              read_from = "end";
            };
          };

          sinks = {
            vector_sink = {
              type = "vector";
              inputs = [ "nginx_logs" ];
              address = "clickhouse:6000";
            };
          };
        };
      };

      systemd.services.vector.serviceConfig = {
        SupplementaryGroups = [ "nginx" ];
      };
    };
  };

  testScript =
  let
    # work around quote/substitution complexity by Nix, Perl, bash and SQL.
    databaseDDL = pkgs.writeText "database.sql" "CREATE DATABASE IF NOT EXISTS nginxdb";

    tableDDL = pkgs.writeText "table.sql" ''
      CREATE TABLE IF NOT EXISTS  nginxdb.access_logs (
        message String
      )
      ENGINE = MergeTree()
      ORDER BY tuple()
    '';

    # Graciously taken from https://clickhouse.com/docs/en/integrations/vector
    tableView = pkgs.writeText "table-view.sql" ''
      CREATE MATERIALIZED VIEW nginxdb.access_logs_view
      (
        RemoteAddr String,
        Client String,
        RemoteUser String,
        TimeLocal DateTime,
        RequestMethod String,
        Request String,
        HttpVersion String,
        Status Int32,
        BytesSent Int64,
        UserAgent String
      )
      ENGINE = MergeTree()
      ORDER BY RemoteAddr
      POPULATE AS
      WITH
       splitByWhitespace(message) as split,
       splitByRegexp('\S \d+ "([^"]*)"', message) as referer
      SELECT
        split[1] AS RemoteAddr,
        split[2] AS Client,
        split[3] AS RemoteUser,
        parseDateTimeBestEffort(replaceOne(trim(LEADING '[' FROM split[4]), ':', ' ')) AS TimeLocal,
        trim(LEADING '"' FROM split[6]) AS RequestMethod,
        split[7] AS Request,
        trim(TRAILING '"' FROM split[8]) AS HttpVersion,
        split[9] AS Status,
        split[10] AS BytesSent,
        trim(BOTH '"' from referer[2]) AS UserAgent
      FROM
        (SELECT message FROM nginxdb.access_logs)
    '';

    selectQuery = pkgs.writeText "select.sql" "SELECT * from nginxdb.access_logs_view";
  in
  ''
    clickhouse.wait_for_unit("clickhouse")
    clickhouse.wait_for_open_port(8123)

    clickhouse.wait_until_succeeds(
      "journalctl -o cat -u clickhouse.service | grep 'Started ClickHouse server'"
    )

    clickhouse.wait_for_unit("vector")
    clickhouse.wait_for_open_port(6000)

    clickhouse.succeed(
      "cat ${databaseDDL} | clickhouse-client"
    )

    clickhouse.succeed(
      "cat ${tableDDL} | clickhouse-client"
    )

    clickhouse.succeed(
      "cat ${tableView} | clickhouse-client"
    )

    nginx.wait_for_unit("nginx")
    nginx.wait_for_open_port(80)
    nginx.wait_for_unit("vector")
    nginx.wait_until_succeeds(
      "journalctl -o cat -u vector.service | grep 'Starting file server'"
    )

    nginx.succeed("curl http://localhost/")
    nginx.succeed("curl http://localhost/")

    nginx.wait_for_file("/var/log/nginx/access.log")
    nginx.wait_until_succeeds(
      "journalctl -o cat -u vector.service | grep 'Found new file to watch. file=/var/log/nginx/access.log'"
    )

    clickhouse.wait_until_succeeds(
      "cat ${selectQuery} | clickhouse-client | grep 'curl'"
    )
  '';
})
