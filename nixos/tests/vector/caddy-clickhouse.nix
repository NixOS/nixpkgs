{ lib, pkgs, ... }:

{
  name = "vector-caddy-clickhouse";
  meta.maintainers = [ pkgs.lib.maintainers.happysalada ];

  nodes = {
    caddy =
      { config, pkgs, ... }:
      {
        networking.firewall.allowedTCPPorts = [ 80 ];

        services.caddy = {
          enable = true;
          virtualHosts = {
            "http://caddy" = {
              extraConfig = ''
                encode gzip

                file_server
                root /srv
              '';
              logFormat = "
                  output file ${config.services.caddy.logDir}/access-caddy.log {
                    mode 0640
                  }
                ";
            };
          };
        };

        systemd.services.vector.serviceConfig = {
          SupplementaryGroups = [ "caddy" ];
        };

        services.vector = {
          enable = true;

          settings = {
            sources = {
              caddy-log = {
                type = "file";
                include = [ "/var/log/caddy/*.log" ];
              };
            };

            transforms = {
              caddy_logs_timestamp = {
                type = "remap";
                inputs = [ "caddy-log" ];
                source = ''
                  .tmp_timestamp, err = parse_json!(.message).ts * 1000000

                  if err != null {
                    log("Unable to parse ts value: " + err, level: "error")
                  } else {
                    .timestamp = from_unix_timestamp!(to_int!(.tmp_timestamp), unit: "microseconds")
                  }

                  del(.tmp_timestamp)
                '';
              };
            };

            sinks = {
              vector_sink = {
                type = "vector";
                inputs = [ "caddy_logs_timestamp" ];
                address = "clickhouse:6000";
              };
            };
          };
        };
      };

    client =
      { config, pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.curl ];
      };

    clickhouse =
      { config, pkgs, ... }:
      {
        virtualisation.memorySize = 4096;

        networking.firewall.allowedTCPPorts = [ 6000 ];

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
                inputs = [
                  "vector_source"
                ];
                endpoint = "http://localhost:8123";
                database = "caddy";
                table = "access_logs";
                date_time_best_effort = true;
                skip_unknown_fields = true;
              };
            };
          };

        };

        services.clickhouse = {
          enable = true;
        };
      };
  };

  testScript =
    let
      # work around quote/substitution complexity by Nix, Perl, bash and SQL.
      databaseDDL = pkgs.writeText "database.sql" "CREATE DATABASE IF NOT EXISTS caddy";

      tableDDL = pkgs.writeText "table.sql" ''
        CREATE TABLE IF NOT EXISTS caddy.access_logs (
          timestamp DateTime64(6),
          host LowCardinality(String),
          message String,
        )
        ENGINE = MergeTree()
        ORDER BY timestamp
        PARTITION BY toYYYYMM(timestamp)
      '';

      tableViewBase = pkgs.writeText "table-view-base.sql" ''
        CREATE TABLE IF NOT EXISTS caddy.access_logs_view_base (
          timestamp DateTime64(6),
          host LowCardinality(String),
          request JSON,
          status UInt16,
        )
        ENGINE = MergeTree()
        ORDER BY timestamp
        PARTITION BY toYYYYMM(timestamp)
      '';

      tableView = pkgs.writeText "table-view.sql" ''
        CREATE MATERIALIZED VIEW IF NOT EXISTS caddy.access_logs_view TO caddy.access_logs_view_base
        AS SELECT
          timestamp,
          host,
          simpleJSONExtractRaw(message, 'request') AS request,
          simpleJSONExtractRaw(message, 'status') AS status
        FROM caddy.access_logs;
      '';

      selectQuery = pkgs.writeText "select.sql" ''
        SELECT
          timestamp,
          request.host,
          request.remote_ip,
          request.proto,
          request.method,
          request.uri,
          status
        FROM caddy.access_logs_view_base
        WHERE request.uri LIKE '%test-uri%'
        FORMAT Pretty
      '';
    in
    ''
      clickhouse.wait_for_unit("clickhouse")
      clickhouse.wait_for_unit("vector")
      clickhouse.wait_for_open_port(6000)
      clickhouse.wait_for_open_port(8123)

      clickhouse.succeed(
        "cat ${databaseDDL} | clickhouse-client",
        "cat ${tableDDL} | clickhouse-client",
        "cat ${tableViewBase} | clickhouse-client",
        "cat ${tableView} | clickhouse-client",
      )

      caddy.wait_for_unit("caddy")
      caddy.wait_for_open_port(80)
      caddy.wait_for_unit("vector")
      caddy.wait_until_succeeds(
        "journalctl -o cat -u vector.service | grep 'Vector has started'"
      )

      client.systemctl("start network-online.target")
      client.wait_until_succeeds("curl http://caddy/test-uri")

      caddy.wait_until_succeeds(
        "journalctl -o cat -u vector.service | grep 'Found new file to watch. file=/var/log/caddy/access-caddy.log'"
      )

      clickhouse.wait_until_succeeds(
        "cat ${selectQuery} | clickhouse-client | grep test-uri"
      )
    '';
}
