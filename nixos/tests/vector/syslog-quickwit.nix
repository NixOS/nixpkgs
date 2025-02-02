import ../make-test-python.nix ({ lib, pkgs, ... }:

# Based on https://quickwit.io/docs/log-management/send-logs/using-vector

{
  name = "vector-syslog-quickwit";
  meta.maintainers = [ pkgs.lib.maintainers.happysalada ];

  nodes = {
    quickwit = { config, pkgs, ... }: {
      environment.systemPackages = [ pkgs.jq ];

      networking.firewall.allowedTCPPorts = [ 7280 ];

      services.quickwit = {
        enable = true;
        settings = {
          listen_address = "::";
        };
      };
    };

    syslog = { config, pkgs, ... }: {
      services.vector = {
        enable = true;

        settings = {
          sources = {
            generate_syslog = {
              type = "demo_logs";
              format = "syslog";
              interval = 0.5;
            };
          };

          transforms = {
            remap_syslog = {
              inputs = ["generate_syslog"];
              type = "remap";
              source = ''
                structured = parse_syslog!(.message)
                .timestamp_nanos = to_unix_timestamp!(structured.timestamp, unit: "nanoseconds")
                .body = structured
                .service_name = structured.appname
                .resource_attributes.source_type = .source_type
                .resource_attributes.host.hostname = structured.hostname
                .resource_attributes.service.name = structured.appname
                .attributes.syslog.procid = structured.procid
                .attributes.syslog.facility = structured.facility
                .attributes.syslog.version = structured.version
                .severity_text = if includes(["emerg", "err", "crit", "alert"], structured.severity) {
                  "ERROR"
                } else if structured.severity == "warning" {
                  "WARN"
                } else if structured.severity == "debug" {
                  "DEBUG"
                } else if includes(["info", "notice"], structured.severity) {
                  "INFO"
                } else {
                 structured.severity
                }
                .scope_name = structured.msgid
                del(.message)
                del(.timestamp)
                del(.service)
                del(.source_type)
              '';
            };
          };

          sinks = {
            #emit_syslog = {
            #  inputs = ["remap_syslog"];
            #  type = "console";
            #  encoding.codec = "json";
            #};
            quickwit_logs = {
              type = "http";
              method = "post";
              inputs = [ "remap_syslog" ];
              encoding.codec = "json";
              framing.method = "newline_delimited";
              uri = "http://quickwit:7280/api/v1/otel-logs-v0_7/ingest";
            };
          };
        };
      };
    };
  };

  testScript =
  let
    aggregationQuery = pkgs.writeText "aggregation-query.json" ''
      {
        "query": "*",
        "max_hits": 0,
        "aggs": {
          "count_per_minute": {
            "histogram": {
                "field": "timestamp_nanos",
                "interval": 60000000
            },
            "aggs": {
              "severity_text_count": {
                "terms": {
                  "field": "severity_text"
                }
              }
            }
          }
        }
      }
    '';
  in
  ''
    quickwit.wait_for_unit("quickwit")
    quickwit.wait_for_open_port(7280)
    quickwit.wait_for_open_port(7281)

    quickwit.wait_until_succeeds(
      "journalctl -o cat -u quickwit.service | grep 'transitioned to ready state'"
    )

    syslog.wait_for_unit("vector")
    syslog.wait_until_succeeds(
      "journalctl -o cat -u vector.service | grep 'Vector has started'"
    )

    quickwit.wait_until_succeeds(
      "journalctl -o cat -u quickwit.service | grep 'publish-new-splits'"
    )

    # Wait for logs to be generated
    # Test below aggregates by the minute
    syslog.sleep(60 * 2)

    quickwit.wait_until_succeeds(
      "curl -sSf -XGET http://127.0.0.1:7280/api/v1/otel-logs-v0_7/search?query=severity_text:ERROR |"
      + " jq '.num_hits' | grep -v '0'"
    )

    quickwit.wait_until_succeeds(
      "journalctl -o cat -u quickwit.service | grep 'SearchRequest'"
    )

    quickwit.wait_until_succeeds(
      "curl -sSf -XPOST -H 'Content-Type: application/json' http://127.0.0.1:7280/api/v1/otel-logs-v0_7/search --data @${aggregationQuery} |"
      + " jq '.num_hits' | grep -v '0'"
    )

    quickwit.wait_until_succeeds(
      "journalctl -o cat -u quickwit.service | grep 'count_per_minute'"
    )
  '';
})
