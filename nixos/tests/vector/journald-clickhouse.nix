{ lib, pkgs, ... }:
let
  # Take the original journald message and create a new payload which only
  # contains the relevant fields - these must match the database columns.
  journalVrlRemapTransform = {
    journald_remap = {
      inputs = [ "journald" ];
      type = "remap";
      source = ''
        m = {}
        m.app = .SYSLOG_IDENTIFIER
        m.host = .host
        m.boot_id = ._BOOT_ID
        m.severity = to_int(.PRIORITY) ?? 0
        m.level = to_syslog_level(m.severity) ?? ""
        m.message = strip_ansi_escape_codes!(.message)
        m.timestamp = .timestamp
        m.uid = to_int(._UID) ?? 0
        m.pid = to_int(._PID) ?? 0
        . = [m]
      '';
    };
  };
in
{
  name = "vector-journald-clickhouse";
  meta.maintainers = [ pkgs.lib.maintainers.happysalada ];

  nodes = {
    clickhouse =
      { config, pkgs, ... }:
      {
        virtualisation.diskSize = 5 * 1024;
        virtualisation.memorySize = 4096;

        networking.firewall.allowedTCPPorts = [ 6000 ];

        services.vector = {
          enable = true;
          journaldAccess = true;

          settings = {
            sources = {
              journald = {
                type = "journald";
              };

              vector_source = {
                type = "vector";
                address = "[::]:6000";
              };
            };

            transforms = journalVrlRemapTransform;

            sinks = {
              clickhouse = {
                type = "clickhouse";
                inputs = [
                  "journald_remap"
                  "vector_source"
                ];
                endpoint = "http://localhost:8123";
                auth = {
                  strategy = "basic";
                  user = "vector";
                  password = "helloclickhouseworld";
                };
                database = "journald";
                table = "logs";
                date_time_best_effort = true;
              };
            };
          };

        };

        services.clickhouse = {
          enable = true;
        };

        # ACL configuration for Vector
        environment = {
          etc."clickhouse-server/users.d/vector.xml".text = ''
            <clickhouse>
              <users>
                <vector>
                  <password>helloclickhouseworld</password>

                  <access_management>0</access_management>

                  <quota>default</quota>
                  <default_database>journald</default_database>

                  <grants>
                    <query>GRANT INSERT ON journald.logs</query>
                  </grants>
                </vector>
              </users>
            </clickhouse>
          '';

          # ACL configuration for read-only client
          etc."clickhouse-server/users.d/grafana.xml".text = ''
            <clickhouse>
              <users>
                <grafana>
                  <password>helloclickhouseworld2</password>

                  <access_management>0</access_management>

                  <quota>default</quota>
                  <default_database>journald</default_database>

                  <grants>
                    <query>GRANT SELECT ON journald.logs</query>
                  </grants>
                </grafana>
              </users>
            </clickhouse>
          '';
        };
      };

    vector =
      { config, pkgs, ... }:
      {
        services.vector = {
          enable = true;
          journaldAccess = true;

          settings = {
            sources = {
              journald = {
                type = "journald";
              };
            };

            transforms = journalVrlRemapTransform;

            sinks = {
              vector_sink = {
                type = "vector";
                inputs = [ "journald_remap" ];
                address = "clickhouse:6000";
              };
            };
          };
        };
      };
  };

  testScript =
    let
      # work around quote/substitution complexity by Nix, Perl, bash and SQL.
      databaseDDL = pkgs.writeText "database.sql" "CREATE DATABASE IF NOT EXISTS journald";

      # https://clickhouse.com/blog/storing-log-data-in-clickhouse-fluent-bit-vector-open-telemetry
      # ORDER BY advice: https://kb.altinity.com/engines/mergetree-table-engine-family/pick-keys/
      tableDDL = pkgs.writeText "table.sql" ''
        CREATE TABLE IF NOT EXISTS journald.logs (
          timestamp DateTime64(6),
          host LowCardinality(String),
          boot_id LowCardinality(String),
          app LowCardinality(String),
          level LowCardinality(String),
          severity UInt8,
          message String,
          uid UInt16,
          pid UInt32,
        )
        ENGINE = MergeTree()
        ORDER BY (host, boot_id, toStartOfHour(timestamp), app, timestamp)
        PARTITION BY toYYYYMM(timestamp)
      '';

      selectQuery = pkgs.writeText "select.sql" ''
        SELECT COUNT(host) FROM journald.logs
        WHERE message LIKE '%Vector has started%'
      '';
    in
    ''
      clickhouse.wait_for_unit("clickhouse")
      clickhouse.wait_for_open_port(6000)
      clickhouse.wait_for_open_port(8123)

      clickhouse.succeed(
        "cat ${databaseDDL} | clickhouse-client"
      )

      clickhouse.succeed(
        "cat ${tableDDL} | clickhouse-client"
      )

      for machine in clickhouse, vector:
        machine.wait_for_unit("vector")
        machine.wait_until_succeeds(
          "journalctl -o cat -u vector.service | grep 'Vector has started'"
        )

      clickhouse.fail(
        "cat ${selectQuery} | clickhouse-client --user vector --password helloclickhouseworld | grep 2"
      )

      clickhouse.wait_until_succeeds(
        "cat ${selectQuery} | clickhouse-client --user grafana --password helloclickhouseworld2 | grep 2"
      )
    '';
}
