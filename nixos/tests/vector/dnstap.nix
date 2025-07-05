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

    knot =
      {
        config,
        nodes,
        pkgs,
        ...
      }:
      let
        exampleZone = pkgs.writeTextDir "example.com.zone" ''
          @ SOA ns.example.com. noc.example.com. 2019031301 86400 7200 3600000 172800
          @       NS      ns1
          @       NS      ns2
          ns1     A       192.168.0.1
          ns1     AAAA    fd00::1
          ns2     A       192.168.0.2
          ns2     AAAA    fd00::2
          www     A       192.0.2.1
          www     AAAA    2001:DB8::1
          sub     NS      ns.example.com.
        '';

        knotZonesEnv = pkgs.buildEnv {
          name = "knot-zones";
          paths = [
            exampleZone
          ];
        };
      in
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

        services.knot = {
          enable = true;
          settings = {
            server = {
              listen = [
                "0.0.0.0@53"
                "::@53"
              ];
              automatic-acl = true;
            };
            template.default = {
              storage = knotZonesEnv;
              dnssec-signing = false;
              # Input-only zone files
              # https://www.knot-dns.cz/docs/2.8/html/operation.html#example-3
              # prevents modification of the zonefiles, since the zonefiles are immutable
              zonefile-sync = -1;
              zonefile-load = "difference";
              journal-content = "changes";
              global-module = "mod-dnstap/capture_all";
            };
            zone = {
              "example.com".file = "example.com.zone";
            };

            mod-dnstap = [
              {
                id = "capture_all";
                sink = "unix:${dnstapSocket}";
              }
            ];
          };
        };

        systemd.services.knot = {
          after = [ "vector.service" ];
          wants = [ "vector.service" ];
          serviceConfig = {
            # DNSTAP access
            ReadWritePaths = [ "/var/run/vector" ];
            SupplementaryGroups = [ "vector" ];
          };
        };
      };

    unbound =
      {
        config,
        nodes,
        pkgs,
        ...
      }:
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

            forward-zone = [
              {
                name = "example.com.";
                forward-addr = [
                  nodes.knot.networking.primaryIPv6Address
                  nodes.knot.networking.primaryIPAddress
                ];
              }
            ];

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
        ORDER BY (serverId, toStartOfHour(timestamp), domain, timestamp)
        POPULATE AS
        SELECT
          timestamp,
          serverId,
          JSONExtractString(requestData.question[1]::String, 'domainName') as domain,
          JSONExtractString(requestData.question[1]::String, 'questionType') as record_type
        FROM dnstap.records
        WHERE messageTypeId = 5 # ClientQuery
      '';

      selectDomainCountQuery = pkgs.writeText "select-domain-count.sql" ''
        SELECT
          domain,
          count(domain)
        FROM dnstap.domains_view
        GROUP BY domain
      '';

      selectAuthResponseQuery = pkgs.writeText "select-auth-response.sql" ''
        SELECT
          *
        FROM dnstap.records
        WHERE messageType = 'AuthResponse'
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

      knot.wait_for_unit("knot")
      unbound.wait_for_unit("unbound")

      for machine in knot, unbound:
        machine.wait_for_unit("vector")

        machine.wait_until_succeeds(
          "journalctl -o cat -u vector.service | grep 'Socket permissions updated to 0o770'"
        )
        machine.wait_until_succeeds(
          "journalctl -o cat -u vector.service | grep 'component_type=dnstap' | grep 'Listening... path=\"${dnstapSocket}\"'"
        )

        machine.wait_for_file("${dnstapSocket}")
        machine.succeed("test 770 -eq $(stat -c '%a' ${dnstapSocket})")

      dnsclient.systemctl("start network-online.target")
      dnsclient.wait_for_unit("network-online.target")
      dnsclient.succeed(
        "dig @unbound test.local",
        "dig @unbound www.example.com"
      )

      unbound.wait_for_file("/var/lib/vector/logs.log")

      unbound.wait_until_succeeds(
        "grep ClientQuery /var/lib/vector/logs.log | grep '\"domainName\":\"test.local.\"' | grep '\"rcodeName\":\"NoError\"'"
      )
      unbound.wait_until_succeeds(
        "grep ClientResponse /var/lib/vector/logs.log | grep '\"domainName\":\"test.local.\"' | grep '\"rData\":\"192.168.123.5\"'"
      )

      clickhouse.log(clickhouse.wait_until_succeeds(
        "cat ${selectDomainCountQuery} | clickhouse-client | grep 'test.local.'"
      ))

      clickhouse.log(clickhouse.wait_until_succeeds(
        "cat ${selectDomainCountQuery} | clickhouse-client | grep 'www.example.com.'"
      ))

      clickhouse.log(clickhouse.wait_until_succeeds(
        "cat ${selectAuthResponseQuery} | clickhouse-client | grep 'Knot DNS ${pkgs.knot-dns.version}'"
      ))
    '';
}
