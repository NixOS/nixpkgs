import ./make-test.nix ({ lib, pkgs, ... }:
let
  escape' = str: lib.replaceChars [''"'' "$" "\n"] [''\\\"'' "\\$" ""] str;

/*
 * The attrset `exporterTests` contains one attribute
 * for each exporter test. Each of these attributes
 * is expected to be an attrset containing:
 *
 *  `exporterConfig`:
 *    this attribute set contains config for the exporter itself
 *
 *  `exporterTest`
 *    this attribute set contains test instructions
 *
 *  `metricProvider` (optional)
 *    this attribute contains additional machine config
 *
 *  Example:
 *    exporterTests.<exporterName> = {
 *      exporterConfig = {
 *        enable = true;
 *      };
 *      metricProvider = {
 *        services.<metricProvider>.enable = true;
 *      };
 *      exporterTest = ''
 *        waitForUnit("prometheus-<exporterName>-exporter.service");
 *        waitForOpenPort("1234");
 *        succeed("curl -sSf 'localhost:1234/metrics'");
 *      '';
 *    };
 *
 *  # this would generate the following test config:
 *
 *    nodes.<exporterName> = {
 *      services.prometheus.<exporterName> = {
 *        enable = true;
 *      };
 *      services.<metricProvider>.enable = true;
 *    };
 *
 *    testScript = ''
 *      $<exporterName>->start();
 *      $<exporterName>->waitForUnit("prometheus-<exporterName>-exporter.service");
 *      $<exporterName>->waitForOpenPort("1234");
 *      $<exporterName>->succeed("curl -sSf 'localhost:1234/metrics'");
 *      $<exporterName>->shutdown();
 *    '';
 */

  exporterTests = {

    blackbox = {
      exporterConfig = {
        enable = true;
        configFile = pkgs.writeText "config.yml" (builtins.toJSON {
          modules.icmp_v6 = {
            prober = "icmp";
            icmp.preferred_ip_protocol = "ip6";
          };
        });
      };
      exporterTest = ''
        waitForUnit("prometheus-blackbox-exporter.service");
        waitForOpenPort(9115);
        succeed("curl -sSf 'http://localhost:9115/probe?target=localhost&module=icmp_v6' | grep -q 'probe_success 1'");
      '';
    };

    collectd = {
      exporterConfig = {
        enable = true;
        extraFlags = [ "--web.collectd-push-path /collectd" ];
      };
      exporterTest =let postData = escape' ''
        [{
          "values":[23],
          "dstypes":["gauge"],
          "type":"gauge",
          "interval":1000,
          "host":"testhost",
          "plugin":"testplugin",
          "time":$(date +%s)
        }]
        ''; in ''
        waitForUnit("prometheus-collectd-exporter.service");
        waitForOpenPort(9103);
        succeed("curl -sSfH 'Content-Type: application/json' -X POST --data \"${postData}\" localhost:9103/collectd");
        succeed("curl -sSf localhost:9103/metrics | grep -q 'collectd_testplugin_gauge{instance=\"testhost\"} 23'");
      '';
    };

    dnsmasq = {
      exporterConfig = {
        enable = true;
        leasesPath = "/var/lib/dnsmasq/dnsmasq.leases";
      };
      metricProvider = {
        services.dnsmasq.enable = true;
      };
      exporterTest = ''
        waitForUnit("prometheus-dnsmasq-exporter.service");
        waitForOpenPort(9153);
        succeed("curl -sSf http://localhost:9153/metrics | grep -q 'dnsmasq_leases 0'");
      '';
    };

    bind = {
      exporterConfig = {
        enable = true;
      };
      metricProvider = {
        services.bind.enable = true;
        services.bind.extraConfig = ''
          statistics-channels {
            inet 127.0.0.1 port 8053 allow { localhost; };
          };
        '';
      };
      exporterTest = ''
        waitForUnit("prometheus-bind-exporter.service");
        waitForOpenPort(9119);
        succeed("curl -sSf http://localhost:9119/metrics" | grep -q 'bind_query_recursions_total 0');
      '';
    };

    dovecot = {
      exporterConfig = {
        enable = true;
        scopes = [ "global" ];
        socketPath = "/var/run/dovecot2/old-stats";
        user = "root"; # <- don't use user root in production
      };
      metricProvider = {
        services.dovecot2.enable = true;
      };
      exporterTest = ''
        waitForUnit("prometheus-dovecot-exporter.service");
        waitForOpenPort(9166);
        succeed("curl -sSf http://localhost:9166/metrics | grep -q 'dovecot_up{scope=\"global\"} 1'");
      '';
    };

    fritzbox = { # TODO add proper test case
      exporterConfig = {
        enable = true;
      };
      exporterTest = ''
        waitForUnit("prometheus-fritzbox-exporter.service");
        waitForOpenPort(9133);
        succeed("curl -sSf http://localhost:9133/metrics | grep -q 'fritzbox_exporter_collect_errors 0'");
      '';
    };

    json = {
      exporterConfig = {
        enable = true;
        url = "http://localhost";
        configFile = pkgs.writeText "json-exporter-conf.json" (builtins.toJSON [{
          name = "json_test_metric";
          path = "$.test";
        }]);
      };
      metricProvider = {
        systemd.services.prometheus-json-exporter.after = [ "nginx.service" ];
        services.nginx = {
          enable = true;
          virtualHosts.localhost.locations."/".extraConfig = ''
            return 200 "{\"test\":1}";
          '';
        };
      };
      exporterTest = ''
        waitForUnit("nginx.service");
        waitForOpenPort(80);
        waitForUnit("prometheus-json-exporter.service");
        waitForOpenPort(7979);
        succeed("curl -sSf localhost:7979/metrics | grep -q 'json_test_metric 1'");
      '';
    };

    nginx = {
      exporterConfig = {
        enable = true;
      };
      metricProvider = {
        services.nginx = {
          enable = true;
          statusPage = true;
          virtualHosts."/".extraConfig = "return 204;";
        };
      };
      exporterTest = ''
        waitForUnit("nginx.service")
        waitForUnit("prometheus-nginx-exporter.service")
        waitForOpenPort(9113)
        succeed("curl -sSf http://localhost:9113/metrics | grep -q 'nginx_up 1'")
      '';
    };

    node = {
      exporterConfig = {
        enable = true;
      };
      exporterTest = ''
        waitForUnit("prometheus-node-exporter.service");
        waitForOpenPort(9100);
        succeed("curl -sSf http://localhost:9100/metrics | grep -q 'node_exporter_build_info{.\\+} 1'");
      '';
    };

    postfix = {
      exporterConfig = {
        enable = true;
      };
      metricProvider = {
        services.postfix.enable = true;
      };
      exporterTest = ''
        waitForUnit("prometheus-postfix-exporter.service");
        waitForOpenPort(9154);
        succeed("curl -sSf http://localhost:9154/metrics | grep -q 'postfix_smtpd_connects_total 0'");
      '';
    };

    snmp = {
      exporterConfig = {
        enable = true;
        configuration.default = {
          version = 2;
          auth.community = "public";
        };
      };
      exporterTest = ''
        waitForUnit("prometheus-snmp-exporter.service");
        waitForOpenPort(9116);
        succeed("curl -sSf localhost:9116/metrics | grep -q 'snmp_request_errors_total 0'");
      '';
    };

    surfboard = {
      exporterConfig = {
        enable = true;
        modemAddress = "localhost";
      };
      metricProvider = {
        systemd.services.prometheus-surfboard-exporter.after = [ "nginx.service" ];
        services.nginx = {
          enable = true;
          virtualHosts.localhost.locations."/cgi-bin/status".extraConfig = ''
            return 204;
          '';
        };
      };
      exporterTest = ''
        waitForUnit("nginx.service");
        waitForOpenPort(80);
        waitForUnit("prometheus-surfboard-exporter.service");
        waitForOpenPort(9239);
        succeed("curl -sSf localhost:9239/metrics | grep -q 'surfboard_up 1'");
      '';
    };

    tor = {
      exporterConfig = {
        enable = true;
      };
      metricProvider = {
        # Note: this does not connect the test environment to the Tor network.
        # Client, relay, bridge or exit connectivity are disabled by default.
        services.tor.enable = true;
        services.tor.controlPort = 9051;
      };
      exporterTest = ''
        waitForUnit("tor.service");
        waitForOpenPort(9051);
        waitForUnit("prometheus-tor-exporter.service");
        waitForOpenPort(9130);
        succeed("curl -sSf localhost:9130/metrics | grep -q 'tor_version{.\\+} 1'");
      '';
    };

    varnish = {
      exporterConfig = {
        enable = true;
        instance = "/var/spool/varnish/varnish";
        group = "varnish";
      };
      metricProvider = {
        systemd.services.prometheus-varnish-exporter.after = [
          "varnish.service"
        ];
        services.varnish = {
          enable = true;
          config = ''
            vcl 4.0;
            backend default {
              .host = "127.0.0.1";
              .port = "80";
            }
          '';
        };
      };
      exporterTest = ''
        waitForUnit("prometheus-varnish-exporter.service");
        waitForOpenPort(9131);
        succeed("curl -sSf http://localhost:9131/metrics | grep -q 'varnish_up 1'");
      '';
    };
  };

  nodes = lib.mapAttrs (exporter: testConfig: lib.mkMerge [{
    services.prometheus.exporters.${exporter} = testConfig.exporterConfig;
  } testConfig.metricProvider or {}]) exporterTests;

  testScript = lib.concatStrings (lib.mapAttrsToList (exporter: testConfig: (''
    subtest "${exporter}", sub {
      ${"$"+exporter}->start();
      ${lib.concatStringsSep "  " (map (line: ''
        ${"$"+exporter}->${line};
      '') (lib.splitString "\n" (lib.removeSuffix "\n" testConfig.exporterTest)))}
      ${"$"+exporter}->shutdown();
    };
  '')) exporterTests);
in
{
  name = "prometheus-exporters";

  inherit nodes testScript;

  meta = with lib.maintainers; {
    maintainers = [ willibutz ];
  };
})
