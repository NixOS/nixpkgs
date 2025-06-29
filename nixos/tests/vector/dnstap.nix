{ lib, pkgs, ... }:

let
  dnstapSocket = "/var/run/vector/dnstap.sock";
in
{
  name = "vector-dnstap";
  meta.maintainers = [ pkgs.lib.maintainers.happysalada ];

  nodes = {
    clickhouse =
      { config, pkgs, ... }:
      {
        networking.firewall.allowedTCPPorts = [ 6000 ];

        services.vector = {
          enable = true;

          settings = {
            sources = {
              vector_dnstap_source = {
                type = "vector";
                address = "[::]:6000";
              };
            };

            sinks = {
              clickhouse = {
                type = "clickhouse";
                inputs = [
                  "vector_dnstap_source"
                ];
                endpoint = "http://localhost:8123";
                database = "dnstap";
                table = "records";
                date_time_best_effort = true;
              };
            };
          };
        };

        services.clickhouse.enable = true;
      };

    unbound =
      { config, pkgs, ... }:
      {
        networking.firewall.allowedUDPPorts = [ 53 ];

        services.vector = {
          enable = true;

          settings = {
            sources = {
              dnstap = {
                type = "dnstap";
                multithreaded = true;
                mode = "unix";
                lowercase_hostnames = true;
                socket_file_mode = 504;
                socket_path = "${dnstapSocket}";
              };
            };

            sinks = {
              file = {
                type = "file";
                inputs = [ "dnstap" ];
                path = "/var/lib/vector/logs.log";
                encoding = {
                  codec = "json";
                };
              };

              vector_dnstap_sink = {
                type = "vector";
                inputs = [ "dnstap" ];
                address = "clickhouse:6000";
              };
            };
          };
        };

        systemd.services.vector.serviceConfig = {
          RuntimeDirectory = "vector";
          RuntimeDirectoryMode = "0770";
        };

        services.unbound = {
          enable = true;
          enableRootTrustAnchor = false;
          package = pkgs.unbound-full;
          settings = {
            server = {
              interface = [
                "0.0.0.0"
                "::"
              ];
              access-control = [
                "192.168.0.0/24 allow"
                "::/0 allow"
              ];

              domain-insecure = "local";
              private-domain = "local";

              local-zone = "local. static";
              local-data = [
                ''"test.local. 10800 IN A 192.168.123.5"''
              ];
            };

            dnstap = {
              dnstap-enable = "yes";
              dnstap-socket-path = "${dnstapSocket}";
              dnstap-send-identity = "yes";
              dnstap-send-version = "yes";
              dnstap-log-client-query-messages = "yes";
              dnstap-log-client-response-messages = "yes";
            };
          };
        };

        systemd.services.unbound = {
          after = [ "vector.service" ];
          wants = [ "vector.service" ];
          serviceConfig = {
            # DNSTAP access
            ReadWritePaths = [ "/var/run/vector" ];
            SupplementaryGroups = [ "vector" ];
          };
        };
      };

    dnsclient =
      { config, pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.dig ];
      };
  };

  testScript =
    let
      # work around quote/substitution complexity by Nix, Perl, bash and SQL.
      databaseDDL = pkgs.writeText "database.sql" "CREATE DATABASE IF NOT EXISTS dnstap";

      tableDDL = pkgs.writeText "table.sql" ''
        CREATE TABLE IF NOT EXISTS dnstap.records (
          timestamp DateTime64(6),
          dataType LowCardinality(String),
          dataTypeId UInt8,
          messageType LowCardinality(String),
          messageTypeId UInt8,
          requestData Nullable(JSON),
          responseData Nullable(JSON),
          responsePort UInt16,
          serverId LowCardinality(String),
          serverVersion LowCardinality(String),
          socketFamily LowCardinality(String),
          socketProtocol LowCardinality(String),
          sourceAddress String,
          sourcePort UInt16,
        )
        ENGINE = MergeTree()
        ORDER BY (serverId, timestamp)
        PARTITION BY toYYYYMM(timestamp)
      '';

      tableView = pkgs.writeText "view.sql" ''
        CREATE MATERIALIZED VIEW dnstap.domains_view (
          timestamp DateTime64(6),
          serverId LowCardinality(String),
          domain String,
          record_type LowCardinality(String)
        )
        ENGINE = MergeTree()
        PARTITION BY toYYYYMM(timestamp)
        ORDER BY (serverId, timestamp)
        POPULATE AS
        SELECT
          timestamp,
          serverId,
          JSONExtractString(requestData.question[1]::String, 'domainName') as domain,
          JSONExtractString(requestData.question[1]::String, 'questionType') as record_type
        FROM dnstap.records
        WHERE messageTypeId = 5 # ClientQuery
      '';

      selectQuery = pkgs.writeText "select.sql" ''
        SELECT
          domain,
          count(domain)
        FROM dnstap.domains_view
        GROUP BY domain
      '';
    in
    ''
      clickhouse.wait_for_unit("clickhouse")
      clickhouse.wait_for_open_port(6000)
      clickhouse.wait_for_open_port(8123)

      clickhouse.succeed(
        "cat ${databaseDDL} | clickhouse-client",
        "cat ${tableDDL} | clickhouse-client",
        "cat ${tableView} | clickhouse-client",
      )

      unbound.wait_for_unit("unbound")
      unbound.wait_for_unit("vector")

      unbound.wait_until_succeeds(
        "journalctl -o cat -u vector.service | grep 'Socket permissions updated to 0o770'"
      )
      unbound.wait_until_succeeds(
        "journalctl -o cat -u vector.service | grep 'component_type=dnstap' | grep 'Listening... path=\"${dnstapSocket}\"'"
      )

      unbound.wait_for_file("${dnstapSocket}")
      unbound.succeed("test 770 -eq $(stat -c '%a' ${dnstapSocket})")

      dnsclient.systemctl("start network-online.target")
      dnsclient.wait_for_unit("network-online.target")
      dnsclient.succeed(
        "dig @unbound test.local"
      )

      unbound.wait_for_file("/var/lib/vector/logs.log")

      unbound.wait_until_succeeds(
        "grep ClientQuery /var/lib/vector/logs.log | grep '\"domainName\":\"test.local.\"' | grep '\"rcodeName\":\"NoError\"'"
      )
      unbound.wait_until_succeeds(
        "grep ClientResponse /var/lib/vector/logs.log | grep '\"domainName\":\"test.local.\"' | grep '\"rData\":\"192.168.123.5\"'"
      )

      clickhouse.log(clickhouse.wait_until_succeeds(
        "cat ${selectQuery} | clickhouse-client | grep 'test.local.'"
      ))
    '';
}
