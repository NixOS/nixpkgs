{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
}:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
  inherit (pkgs.lib) concatStringsSep maintainers mapAttrs mkMerge
                     removeSuffix replaceChars singleton splitString;

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
 *        wait_for_unit("prometheus-<exporterName>-exporter.service")
 *        wait_for_open_port("1234")
 *        succeed("curl -sSf 'localhost:1234/metrics'")
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
 *      <exporterName>.start()
 *      <exporterName>.wait_for_unit("prometheus-<exporterName>-exporter.service")
 *      <exporterName>.wait_for_open_port("1234")
 *      <exporterName>.succeed("curl -sSf 'localhost:1234/metrics'")
 *      <exporterName>.shutdown()
 *    '';
 */

  exporterTests = {

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
        wait_for_unit("prometheus-bind-exporter.service")
        wait_for_open_port(9119)
        succeed(
            "curl -sSf http://localhost:9119/metrics | grep -q 'bind_query_recursions_total 0'"
        )
      '';
    };

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
        wait_for_unit("prometheus-blackbox-exporter.service")
        wait_for_open_port(9115)
        succeed(
            "curl -sSf 'http://localhost:9115/probe?target=localhost&module=icmp_v6' | grep -q 'probe_success 1'"
        )
      '';
    };

    collectd = {
      exporterConfig = {
        enable = true;
        extraFlags = [ "--web.collectd-push-path /collectd" ];
      };
      exporterTest = let postData = replaceChars [ "\n" ] [ "" ] ''
        [{
          "values":[23],
          "dstypes":["gauge"],
          "type":"gauge",
          "interval":1000,
          "host":"testhost",
          "plugin":"testplugin",
          "time":DATE
        }]
        ''; in ''
        wait_for_unit("prometheus-collectd-exporter.service")
        wait_for_open_port(9103)
        succeed(
            'echo \'${postData}\'> /tmp/data.json'
        )
        succeed('sed -ie "s DATE $(date +%s) " /tmp/data.json')
        succeed(
            "curl -sSfH 'Content-Type: application/json' -X POST --data @/tmp/data.json localhost:9103/collectd"
        )
        succeed(
            "curl -sSf localhost:9103/metrics | grep -q 'collectd_testplugin_gauge{instance=\"testhost\"} 23'"
        )
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
        wait_for_unit("prometheus-dnsmasq-exporter.service")
        wait_for_open_port(9153)
        succeed("curl -sSf http://localhost:9153/metrics | grep -q 'dnsmasq_leases 0'")
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
        wait_for_unit("prometheus-dovecot-exporter.service")
        wait_for_open_port(9166)
        succeed(
            "curl -sSf http://localhost:9166/metrics | grep -q 'dovecot_up{scope=\"global\"} 1'"
        )
      '';
    };

    fritzbox = { # TODO add proper test case
      exporterConfig = {
        enable = true;
      };
      exporterTest = ''
        wait_for_unit("prometheus-fritzbox-exporter.service")
        wait_for_open_port(9133)
        succeed(
            "curl -sSf http://localhost:9133/metrics | grep -q 'fritzbox_exporter_collect_errors 0'"
        )
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
        wait_for_unit("nginx.service")
        wait_for_open_port(80)
        wait_for_unit("prometheus-json-exporter.service")
        wait_for_open_port(7979)
        succeed("curl -sSf localhost:7979/metrics | grep -q 'json_test_metric 1'")
      '';
    };

    mail = {
      exporterConfig = {
        enable = true;
        configuration = {
          monitoringInterval = "2s";
          mailCheckTimeout = "10s";
          servers = [ {
            name = "testserver";
            server = "localhost";
            port = 25;
            from = "mail-exporter@localhost";
            to = "mail-exporter@localhost";
            detectionDir = "/var/spool/mail/mail-exporter/new";
          } ];
        };
      };
      metricProvider = {
        services.postfix.enable = true;
        systemd.services.prometheus-mail-exporter = {
          after = [ "postfix.service" ];
          requires = [ "postfix.service" ];
          preStart = ''
            mkdir -p -m 0700 mail-exporter/new
          '';
          serviceConfig = {
            ProtectHome = true;
            ReadOnlyPaths = "/";
            ReadWritePaths = "/var/spool/mail";
            WorkingDirectory = "/var/spool/mail";
          };
        };
        users.users.mailexporter.isSystemUser = true;
      };
      exporterTest = ''
        wait_for_unit("postfix.service")
        wait_for_unit("prometheus-mail-exporter.service")
        wait_for_open_port(9225)
        wait_until_succeeds(
            "curl -sSf http://localhost:9225/metrics | grep -q 'mail_deliver_success{configname=\"testserver\"} 1'"
        )
      '';
    };

    mikrotik = {
      exporterConfig = {
        enable = true;
        extraFlags = [ "-timeout=1s" ];
        configuration = {
          devices = [
            {
              name = "router";
              address = "192.168.42.48";
              user = "prometheus";
              password = "shh";
            }
          ];
          features = {
            bgp = true;
            dhcp = true;
            dhcpl = true;
            dhcpv6 = true;
            health = true;
            routes = true;
            poe = true;
            pools = true;
            optics = true;
            w60g = true;
            wlansta = true;
            wlanif = true;
            monitor = true;
            ipsec = true;
          };
        };
      };
      exporterTest = ''
        wait_for_unit("prometheus-mikrotik-exporter.service")
        wait_for_open_port(9436)
        succeed(
            "curl -sSf http://localhost:9436/metrics | grep -q 'mikrotik_scrape_collector_success{device=\"router\"} 0'"
        )
      '';
    };

    nextcloud = {
      exporterConfig = {
        enable = true;
        passwordFile = "/var/nextcloud-pwfile";
        url = "http://localhost/negative-space.xml";
      };
      metricProvider = {
        systemd.services.nc-pwfile = let
          passfile = (pkgs.writeText "pwfile" "snakeoilpw");
        in {
          requiredBy = [ "prometheus-nextcloud-exporter.service" ];
          before = [ "prometheus-nextcloud-exporter.service" ];
          serviceConfig.ExecStart = ''
            ${pkgs.coreutils}/bin/install -o nextcloud-exporter -m 0400 ${passfile} /var/nextcloud-pwfile
          '';
        };
        services.nginx = {
          enable = true;
          virtualHosts."localhost" = {
            basicAuth.nextcloud-exporter = "snakeoilpw";
            locations."/" = {
              root = "${pkgs.prometheus-nextcloud-exporter.src}/serverinfo/testdata";
            };
          };
        };
      };
      exporterTest = ''
        wait_for_unit("nginx.service")
        wait_for_unit("prometheus-nextcloud-exporter.service")
        wait_for_open_port(9205)
        succeed("curl -sSf http://localhost:9205/metrics | grep -q 'nextcloud_up 1'")
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
          virtualHosts."test".extraConfig = "return 204;";
        };
      };
      exporterTest = ''
        wait_for_unit("nginx.service")
        wait_for_unit("prometheus-nginx-exporter.service")
        wait_for_open_port(9113)
        succeed("curl -sSf http://localhost:9113/metrics | grep -q 'nginx_up 1'")
      '';
    };

    node = {
      exporterConfig = {
        enable = true;
      };
      exporterTest = ''
        wait_for_unit("prometheus-node-exporter.service")
        wait_for_open_port(9100)
        succeed(
            "curl -sSf http://localhost:9100/metrics | grep -q 'node_exporter_build_info{.\\+} 1'"
        )
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
        wait_for_unit("prometheus-postfix-exporter.service")
        wait_for_open_port(9154)
        succeed(
            "curl -sSf http://localhost:9154/metrics | grep -q 'postfix_smtpd_connects_total 0'"
        )
      '';
    };

    postgres = {
      exporterConfig = {
        enable = true;
        runAsLocalSuperUser = true;
      };
      metricProvider = {
        services.postgresql.enable = true;
      };
      exporterTest = ''
        wait_for_unit("prometheus-postgres-exporter.service")
        wait_for_open_port(9187)
        wait_for_unit("postgresql.service")
        succeed(
            "curl -sSf http://localhost:9187/metrics | grep -q 'pg_exporter_last_scrape_error 0'"
        )
        succeed("curl -sSf http://localhost:9187/metrics | grep -q 'pg_up 1'")
        systemctl("stop postgresql.service")
        succeed(
            "curl -sSf http://localhost:9187/metrics | grep -qv 'pg_exporter_last_scrape_error 0'"
        )
        succeed("curl -sSf http://localhost:9187/metrics | grep -q 'pg_up 0'")
        systemctl("start postgresql.service")
        wait_for_unit("postgresql.service")
        succeed(
            "curl -sSf http://localhost:9187/metrics | grep -q 'pg_exporter_last_scrape_error 0'"
        )
        succeed("curl -sSf http://localhost:9187/metrics | grep -q 'pg_up 1'")
      '';
    };

    rspamd = {
      exporterConfig = {
        enable = true;
      };
      metricProvider = {
        services.rspamd.enable = true;
        virtualisation.memorySize = 1024;
      };
      exporterTest = ''
        wait_for_unit("rspamd.service")
        wait_for_unit("prometheus-rspamd-exporter.service")
        wait_for_open_port(11334)
        wait_for_open_port(7980)
        wait_until_succeeds(
            "curl -sSf localhost:7980/metrics | grep -q 'rspamd_scanned{host=\"rspamd\"} 0'"
        )
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
        wait_for_unit("prometheus-snmp-exporter.service")
        wait_for_open_port(9116)
        succeed("curl -sSf localhost:9116/metrics | grep -q 'snmp_request_errors_total 0'")
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
        wait_for_unit("nginx.service")
        wait_for_open_port(80)
        wait_for_unit("prometheus-surfboard-exporter.service")
        wait_for_open_port(9239)
        succeed("curl -sSf localhost:9239/metrics | grep -q 'surfboard_up 1'")
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
        wait_for_unit("tor.service")
        wait_for_open_port(9051)
        wait_for_unit("prometheus-tor-exporter.service")
        wait_for_open_port(9130)
        succeed("curl -sSf localhost:9130/metrics | grep -q 'tor_version{.\\+} 1'")
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
        wait_for_unit("prometheus-varnish-exporter.service")
        wait_for_open_port(6081)
        wait_for_open_port(9131)
        succeed("curl -sSf http://localhost:9131/metrics | grep -q 'varnish_up 1'")
      '';
    };

    wireguard = let snakeoil = import ./wireguard/snakeoil-keys.nix; in {
      exporterConfig.enable = true;
      metricProvider = {
        networking.wireguard.interfaces.wg0 = {
          ips = [ "10.23.42.1/32" "fc00::1/128" ];
          listenPort = 23542;

          inherit (snakeoil.peer0) privateKey;

          peers = singleton {
            allowedIPs = [ "10.23.42.2/32" "fc00::2/128" ];

            inherit (snakeoil.peer1) publicKey;
          };
        };
        systemd.services.prometheus-wireguard-exporter.after = [ "wireguard-wg0.service" ];
      };
      exporterTest = ''
        wait_for_unit("prometheus-wireguard-exporter.service")
        wait_for_open_port(9586)
        wait_until_succeeds(
            "curl -sSf http://localhost:9586/metrics | grep '${snakeoil.peer1.publicKey}'"
        )
      '';
    };
  };
in
mapAttrs (exporter: testConfig: (makeTest {
  name = "prometheus-${exporter}-exporter";

  nodes.${exporter} = mkMerge [{
    services.prometheus.exporters.${exporter} = testConfig.exporterConfig;
  } testConfig.metricProvider or {}];

  testScript = ''
    ${exporter}.start()
    ${concatStringsSep "\n" (map (line:
      if (builtins.substring 0 1 line == " " || builtins.substring 0 1 line == ")")
      then line
      else "${exporter}.${line}"
    ) (splitString "\n" (removeSuffix "\n" testConfig.exporterTest)))}
    ${exporter}.shutdown()
  '';

  meta = with maintainers; {
    maintainers = [ willibutz ];
  };
})) exporterTests
