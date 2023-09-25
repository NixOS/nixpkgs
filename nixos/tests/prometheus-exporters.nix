{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
}:

let
  inherit (import ../lib/testing-python.nix { inherit system pkgs; }) makeTest;
  inherit (pkgs.lib) concatStringsSep maintainers mapAttrs mkMerge
    removeSuffix replaceStrings singleton splitString makeBinPath;

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
    *  `nodeName` (optional)
    *    override an incompatible testnode name
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
    *        wait_for_open_port(1234)
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
    *      <exporterName>.wait_for_open_port(1234)
    *      <exporterName>.succeed("curl -sSf 'localhost:1234/metrics'")
    *      <exporterName>.shutdown()
    *    '';
  */

  exporterTests = {
    apcupsd = {
      exporterConfig = {
        enable = true;
      };
      metricProvider = {
        services.apcupsd.enable = true;
      };
      exporterTest = ''
        wait_for_unit("apcupsd.service")
        wait_for_open_port(3551)
        wait_for_unit("prometheus-apcupsd-exporter.service")
        wait_for_open_port(9162)
        succeed("curl -sSf http://localhost:9162/metrics | grep 'apcupsd_info'")
      '';
    };

    artifactory = {
      exporterConfig = {
        enable = true;
        artiUsername = "artifactory-username";
        artiPassword = "artifactory-password";
      };
      exporterTest = ''
        wait_for_unit("prometheus-artifactory-exporter.service")
        wait_for_open_port(9531)
        succeed(
            "curl -sSf http://localhost:9531/metrics | grep 'artifactory_up'"
        )
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
        wait_for_unit("prometheus-bind-exporter.service")
        wait_for_open_port(9119)
        succeed(
            "curl -sSf http://localhost:9119/metrics | grep 'bind_query_recursions_total 0'"
        )
      '';
    };

    bird = {
      exporterConfig = {
        enable = true;
      };
      metricProvider = {
        services.bird2.enable = true;
        services.bird2.config = ''
          router id 127.0.0.1;

          protocol kernel MyObviousTestString {
            ipv4 {
              import all;
              export none;
            };
          }

          protocol device {
          }
        '';
      };
      exporterTest = ''
        wait_for_unit("prometheus-bird-exporter.service")
        wait_for_open_port(9324)
        wait_until_succeeds(
            "curl -sSf http://localhost:9324/metrics | grep 'MyObviousTestString'"
        )
      '';
    };

    bitcoin = {
      exporterConfig = {
        enable = true;
        rpcUser = "bitcoinrpc";
        rpcPasswordFile = pkgs.writeText "password" "hunter2";
      };
      metricProvider = {
        services.bitcoind.default.enable = true;
        services.bitcoind.default.rpc.users.bitcoinrpc.passwordHMAC = "e8fe33f797e698ac258c16c8d7aadfbe$872bdb8f4d787367c26bcfd75e6c23c4f19d44a69f5d1ad329e5adf3f82710f7";
      };
      exporterTest = ''
        wait_for_unit("prometheus-bitcoin-exporter.service")
        wait_for_unit("bitcoind-default.service")
        wait_for_open_port(9332)
        succeed("curl -sSf http://localhost:9332/metrics | grep '^bitcoin_blocks '")
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
            "curl -sSf 'http://localhost:9115/probe?target=localhost&module=icmp_v6' | grep 'probe_success 1'"
        )
      '';
    };

    collectd = {
      exporterConfig = {
        enable = true;
        extraFlags = [ "--web.collectd-push-path /collectd" ];
      };
      exporterTest = let postData = replaceStrings [ "\n" ] [ "" ] ''
        [{
          "values":[23],
          "dstypes":["gauge"],
          "type":"gauge",
          "interval":1000,
          "host":"testhost",
          "plugin":"testplugin",
          "time":DATE
        }]
      ''; in
        ''
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
              "curl -sSf localhost:9103/metrics | grep 'collectd_testplugin_gauge{instance=\"testhost\"} 23'"
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
        succeed("curl -sSf http://localhost:9153/metrics | grep 'dnsmasq_leases 0'")
      '';
    };

    # Access to WHOIS server is required to properly test this exporter, so
    # just perform basic sanity check that the exporter is running and returns
    # a failure.
    domain = {
      exporterConfig = {
        enable = true;
      };
      exporterTest = ''
        wait_for_unit("prometheus-domain-exporter.service")
        wait_for_open_port(9222)
        succeed("curl -sSf 'http://localhost:9222/probe?target=nixos.org'")
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
            "curl -sSf http://localhost:9166/metrics | grep 'dovecot_up{scope=\"global\"} 1'"
        )
      '';
    };

    fastly = {
      exporterConfig = {
        enable = true;
        tokenPath = pkgs.writeText "token" "abc123";
      };

      # noop: fastly's exporter can't start without first talking to fastly
      # see: https://github.com/peterbourgon/fastly-exporter/issues/87
      exporterTest = ''
        succeed("true");
      '';
    };

    fritzbox = {
      # TODO add proper test case
      exporterConfig = {
        enable = true;
      };
      exporterTest = ''
        wait_for_unit("prometheus-fritzbox-exporter.service")
        wait_for_open_port(9133)
        succeed(
            "curl -sSf http://localhost:9133/metrics | grep 'fritzbox_exporter_collect_errors 0'"
        )
      '';
    };

    graphite = {
      exporterConfig = {
        enable = true;
        port = 9108;
        graphitePort = 9109;
        mappingSettings.mappings = [{
          match = "test.*.*";
          name = "testing";
          labels = {
            protocol = "$1";
            author = "$2";
          };
        }];
      };
      exporterTest = ''
        wait_for_unit("prometheus-graphite-exporter.service")
        wait_for_open_port(9108)
        wait_for_open_port(9109)
        succeed("echo test.tcp.foo-bar 1234 $(date +%s) | nc -w1 localhost 9109")
        succeed("curl -sSf http://localhost:9108/metrics | grep 'testing{author=\"foo-bar\",protocol=\"tcp\"} 1234'")
      '';
    };

    idrac = {
      exporterConfig = {
        enable = true;
        port = 9348;
        configuration = {
          hosts = {
            default = { username = "username"; password = "password"; };
          };
        };
      };
      exporterTest = ''
        wait_for_unit("prometheus-idrac-exporter.service")
        wait_for_open_port(9348)
        wait_until_succeeds("curl localhost:9348")
      '';
    };

    influxdb = {
      exporterConfig = {
        enable = true;
        sampleExpiry = "3s";
      };
      exporterTest = ''
        wait_for_unit("prometheus-influxdb-exporter.service")
        wait_for_open_port(9122)
        succeed(
          "curl -XPOST http://localhost:9122/write --data-binary 'influxdb_exporter,distro=nixos,added_in=21.09 value=1'"
        )
        succeed(
          "curl -sSf http://localhost:9122/metrics | grep 'nixos'"
        )
        execute("sleep 5")
        fail(
          "curl -sSf http://localhost:9122/metrics | grep 'nixos'"
        )
      '';
    };

    ipmi = {
      exporterConfig = {
        enable = true;
      };
      exporterTest = ''
        wait_for_unit("prometheus-ipmi-exporter.service")
        wait_for_open_port(9290)
        succeed(
          "curl -sSf http://localhost:9290/metrics | grep 'ipmi_scrape_duration_seconds'"
        )
      '';
    };

    jitsi = {
      exporterConfig = {
        enable = true;
      };
      metricProvider = {
        systemd.services.prometheus-jitsi-exporter.after = [ "jitsi-videobridge2.service" ];
        services.jitsi-videobridge = {
          enable = true;
          colibriRestApi = true;
        };
      };
      exporterTest = ''
        wait_for_unit("jitsi-videobridge2.service")
        wait_for_open_port(8080)
        wait_for_unit("prometheus-jitsi-exporter.service")
        wait_for_open_port(9700)
        wait_until_succeeds(
            'journalctl -eu prometheus-jitsi-exporter.service -o cat | grep "key=participants"'
        )
        succeed("curl -sSf 'localhost:9700/metrics' | grep 'jitsi_participants 0'")
      '';
    };

    json = {
      exporterConfig = {
        enable = true;
        url = "http://localhost";
        configFile = pkgs.writeText "json-exporter-conf.json" (builtins.toJSON {
          modules = {
            default = {
              metrics = [
                { name = "json_test_metric"; path = "{ .test }"; }
              ];
            };
          };
        });
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
        succeed(
            "curl -sSf 'localhost:7979/probe?target=http://localhost' | grep 'json_test_metric 1'"
        )
      '';
    };

    kea = let
      controlSocketPathV4 = "/run/kea/dhcp4.sock";
      controlSocketPathV6 = "/run/kea/dhcp6.sock";
    in
    {
      exporterConfig = {
        enable = true;
        controlSocketPaths = [
          controlSocketPathV4
          controlSocketPathV6
        ];
      };
      metricProvider = {
        services.kea = {
          dhcp4 = {
            enable = true;
            settings = {
              control-socket = {
                socket-type = "unix";
                socket-name = controlSocketPathV4;
              };
            };
          };
          dhcp6 = {
            enable = true;
            settings = {
              control-socket = {
                socket-type = "unix";
                socket-name = controlSocketPathV6;
              };
            };
          };
        };
      };

      exporterTest = ''
        wait_for_unit("kea-dhcp4-server.service")
        wait_for_unit("kea-dhcp6-server.service")
        wait_for_file("${controlSocketPathV4}")
        wait_for_file("${controlSocketPathV6}")
        wait_for_unit("prometheus-kea-exporter.service")
        wait_for_open_port(9547)
        succeed(
            "curl --fail localhost:9547/metrics | grep 'packets_received_total'"
        )
      '';
    };

    knot = {
      exporterConfig = {
        enable = true;
      };
      metricProvider = {
        services.knot = {
          enable = true;
          extraArgs = [ "-v" ];
          extraConfig = ''
            server:
              listen: 127.0.0.1@53

            template:
              - id: default
                global-module: mod-stats
                dnssec-signing: off
                zonefile-sync: -1
                journal-db: /var/lib/knot/journal
                kasp-db: /var/lib/knot/kasp
                timer-db: /var/lib/knot/timer
                zonefile-load: difference
                storage: ${pkgs.buildEnv {
                  name = "foo";
                  paths = [
                    (pkgs.writeTextDir "test.zone" ''
                      @ SOA ns.example.com. noc.example.com. 2019031301 86400 7200 3600000 172800
                      @       NS      ns1
                      @       NS      ns2
                      ns1     A       192.168.0.1
                    '')
                  ];
                }}

            mod-stats:
              - id: custom
                edns-presence: on
                query-type: on

            zone:
              - domain: test
                file: test.zone
                module: mod-stats/custom
          '';
        };
      };
      exporterTest = ''
        wait_for_unit("knot.service")
        wait_for_unit("prometheus-knot-exporter.service")
        wait_for_open_port(9433)
        succeed("curl -sSf 'localhost:9433' | grep 'knot_server_zone_count 1.0'")
      '';
    };

    keylight = {
      # A hardware device is required to properly test this exporter, so just
      # perform a couple of basic sanity checks that the exporter is running
      # and requires a target, but cannot reach a specified target.
      exporterConfig = {
        enable = true;
      };
      exporterTest = ''
        wait_for_unit("prometheus-keylight-exporter.service")
        wait_for_open_port(9288)
        succeed(
            "curl -sS --write-out '%{http_code}' -o /dev/null http://localhost:9288/metrics | grep '400'"
        )
        succeed(
            "curl -sS --write-out '%{http_code}' -o /dev/null http://localhost:9288/metrics?target=nosuchdevice | grep '500'"
        )
      '';
    };

    lnd = {
      exporterConfig = {
        enable = true;
        lndTlsPath = "/var/lib/lnd/tls.cert";
        lndMacaroonDir = "/var/lib/lnd";
        extraFlags = [ "--lnd.network=regtest" ];
      };
      metricProvider = {
        systemd.services.prometheus-lnd-exporter.serviceConfig.RestartSec = 15;
        systemd.services.prometheus-lnd-exporter.after = [ "lnd.service" ];
        services.bitcoind.regtest = {
          enable = true;
          extraConfig = ''
            rpcauth=bitcoinrpc:e8fe33f797e698ac258c16c8d7aadfbe$872bdb8f4d787367c26bcfd75e6c23c4f19d44a69f5d1ad329e5adf3f82710f7
            zmqpubrawblock=tcp://127.0.0.1:28332
            zmqpubrawtx=tcp://127.0.0.1:28333
          '';
          extraCmdlineOptions = [ "-regtest" ];
        };
        systemd.services.lnd = {
          serviceConfig.ExecStart = ''
            ${pkgs.lnd}/bin/lnd \
              --datadir=/var/lib/lnd \
              --tlscertpath=/var/lib/lnd/tls.cert \
              --tlskeypath=/var/lib/lnd/tls.key \
              --logdir=/var/log/lnd \
              --bitcoin.active \
              --bitcoin.regtest \
              --bitcoin.node=bitcoind \
              --bitcoind.rpcuser=bitcoinrpc \
              --bitcoind.rpcpass=hunter2 \
              --bitcoind.zmqpubrawblock=tcp://127.0.0.1:28332 \
              --bitcoind.zmqpubrawtx=tcp://127.0.0.1:28333 \
              --readonlymacaroonpath=/var/lib/lnd/readonly.macaroon
          '';
          serviceConfig.StateDirectory = "lnd";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
        };
        # initialize wallet, creates macaroon needed by exporter
        systemd.services.lnd.postStart = ''
          ${pkgs.curl}/bin/curl \
            --retry 20 \
            --retry-delay 1 \
            --retry-connrefused \
            --cacert /var/lib/lnd/tls.cert \
            -X GET \
            https://localhost:8080/v1/genseed | ${pkgs.jq}/bin/jq -c '.cipher_seed_mnemonic' > /tmp/seed
          ${pkgs.curl}/bin/curl \
            --retry 20 \
            --retry-delay 1 \
            --retry-connrefused \
            --cacert /var/lib/lnd/tls.cert \
            -X POST \
            -d "{\"wallet_password\": \"asdfasdfasdf\", \"cipher_seed_mnemonic\": $(cat /tmp/seed | tr -d '\n')}" \
            https://localhost:8080/v1/initwallet
        '';
      };
      exporterTest = ''
        wait_for_unit("lnd.service")
        wait_for_open_port(10009)
        wait_for_unit("prometheus-lnd-exporter.service")
        wait_for_open_port(9092)
        succeed("curl -sSf localhost:9092/metrics | grep '^lnd_peer_count'")
      '';
    };

    mail = {
      exporterConfig = {
        enable = true;
        configuration = {
          monitoringInterval = "2s";
          mailCheckTimeout = "10s";
          servers = [{
            name = "testserver";
            server = "localhost";
            port = 25;
            from = "mail-exporter@localhost";
            to = "mail-exporter@localhost";
            detectionDir = "/var/spool/mail/mail-exporter/new";
          }];
        };
      };
      metricProvider = {
        services.postfix.enable = true;
        systemd.services.prometheus-mail-exporter = {
          after = [ "postfix.service" ];
          requires = [ "postfix.service" ];
          serviceConfig = {
            ExecStartPre = [
              "${pkgs.writeShellScript "create-maildir" ''
                mkdir -p -m 0700 mail-exporter/new
              ''}"
            ];
            ProtectHome = true;
            ReadOnlyPaths = "/";
            ReadWritePaths = "/var/spool/mail";
            WorkingDirectory = "/var/spool/mail";
          };
        };
        users.users.mailexporter = {
          isSystemUser = true;
          group = "mailexporter";
        };
        users.groups.mailexporter = {};
      };
      exporterTest = ''
        wait_for_unit("postfix.service")
        wait_for_unit("prometheus-mail-exporter.service")
        wait_for_open_port(9225)
        wait_until_succeeds(
            "curl -sSf http://localhost:9225/metrics | grep 'mail_deliver_success{configname=\"testserver\"} 1'"
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
            "curl -sSf http://localhost:9436/metrics | grep 'mikrotik_scrape_collector_success{device=\"router\"} 0'"
        )
      '';
    };

    modemmanager = {
      exporterConfig = {
        enable = true;
        refreshRate = "10s";
      };
      metricProvider = {
        # ModemManager is installed when NetworkManager is enabled. Ensure it is
        # started and is wanted by NM and the exporter to start everything up
        # in the right order.
        networking.networkmanager.enable = true;
        systemd.services.ModemManager = {
          enable = true;
          wantedBy = [ "NetworkManager.service" "prometheus-modemmanager-exporter.service" ];
        };
      };
      exporterTest = ''
        wait_for_unit("ModemManager.service")
        wait_for_unit("prometheus-modemmanager-exporter.service")
        wait_for_open_port(9539)
        succeed(
            "curl -sSf http://localhost:9539/metrics | grep 'modemmanager_info'"
        )
      '';
    };

    mysqld = {
      exporterConfig = {
        enable = true;
        runAsLocalSuperUser = true;
        configFile = pkgs.writeText "test-prometheus-exporter-mysqld-config.my-cnf" ''
          [client]
          user = exporter
          password = snakeoilpassword
        '';
      };
      metricProvider = {
        services.mysql = {
          enable = true;
          package = pkgs.mariadb;
          initialScript = pkgs.writeText "mysql-init-script.sql" ''
            CREATE USER 'exporter'@'localhost'
            IDENTIFIED BY 'snakeoilpassword'
            WITH MAX_USER_CONNECTIONS 3;
            GRANT PROCESS, REPLICATION CLIENT, SLAVE MONITOR, SELECT ON *.* TO 'exporter'@'localhost';
          '';
        };
      };
      exporterTest = ''
        wait_for_unit("prometheus-mysqld-exporter.service")
        wait_for_open_port(9104)
        wait_for_unit("mysql.service")
        succeed("curl -sSf http://localhost:9104/metrics | grep 'mysql_up 1'")
        systemctl("stop mysql.service")
        succeed("curl -sSf http://localhost:9104/metrics | grep 'mysql_up 0'")
        systemctl("start mysql.service")
        wait_for_unit("mysql.service")
        succeed("curl -sSf http://localhost:9104/metrics | grep 'mysql_up 1'")
      '';
    };

    nextcloud = {
      exporterConfig = {
        enable = true;
        passwordFile = "/var/nextcloud-pwfile";
        url = "http://localhost";
      };
      metricProvider = {
        systemd.services.nc-pwfile =
          let
            passfile = (pkgs.writeText "pwfile" "snakeoilpw");
          in
          {
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
              tryFiles = "/negative-space.json =404";
            };
          };
        };
      };
      exporterTest = ''
        wait_for_unit("nginx.service")
        wait_for_unit("prometheus-nextcloud-exporter.service")
        wait_for_open_port(9205)
        succeed("curl -sSf http://localhost:9205/metrics | grep 'nextcloud_up 1'")
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
        succeed("curl -sSf http://localhost:9113/metrics | grep 'nginx_up 1'")
      '';
    };

    nginxlog = {
      exporterConfig = {
        enable = true;
        group = "nginx";
        settings = {
          namespaces = [
            {
              name = "filelogger";
              source = {
                files = [ "/var/log/nginx/filelogger.access.log" ];
              };
            }
            {
              name = "syslogger";
              source = {
                syslog = {
                  listen_address = "udp://127.0.0.1:10000";
                  format = "rfc3164";
                  tags = [ "nginx" ];
                };
              };
            }
          ];
        };
      };
      metricProvider = {
        services.nginx = {
          enable = true;
          httpConfig = ''
            server {
              listen 80;
              server_name filelogger.local;
              access_log /var/log/nginx/filelogger.access.log;
            }
            server {
              listen 81;
              server_name syslogger.local;
              access_log syslog:server=127.0.0.1:10000,tag=nginx,severity=info;
            }
          '';
        };
      };
      exporterTest = ''
        wait_for_unit("nginx.service")
        wait_for_unit("prometheus-nginxlog-exporter.service")
        wait_for_open_port(9117)
        wait_for_open_port(80)
        wait_for_open_port(81)
        succeed("curl http://localhost")
        execute("sleep 1")
        succeed(
            "curl -sSf http://localhost:9117/metrics | grep 'filelogger_http_response_count_total' | grep 1"
        )
        succeed("curl http://localhost:81")
        execute("sleep 1")
        succeed(
            "curl -sSf http://localhost:9117/metrics | grep 'syslogger_http_response_count_total' | grep 1"
        )
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
            "curl -sSf http://localhost:9100/metrics | grep 'node_exporter_build_info{.\\+} 1'"
        )
      '';
    };

    openldap = {
      exporterConfig = {
        enable = true;
        ldapCredentialFile = "${pkgs.writeText "exporter.yml" ''
          ldapUser: "cn=root,dc=example"
          ldapPass: "notapassword"
        ''}";
      };
      metricProvider = {
        services.openldap = {
          enable = true;
          settings.children = {
            "cn=schema".includes = [
              "${pkgs.openldap}/etc/schema/core.ldif"
              "${pkgs.openldap}/etc/schema/cosine.ldif"
              "${pkgs.openldap}/etc/schema/inetorgperson.ldif"
              "${pkgs.openldap}/etc/schema/nis.ldif"
            ];
            "olcDatabase={1}mdb" = {
              attrs = {
                objectClass = [ "olcDatabaseConfig" "olcMdbConfig" ];
                olcDatabase = "{1}mdb";
                olcDbDirectory = "/var/db/openldap";
                olcSuffix = "dc=example";
                olcRootDN = {
                  # cn=root,dc=example
                  base64 = "Y249cm9vdCxkYz1leGFtcGxl";
                };
                olcRootPW = {
                  path = "${pkgs.writeText "rootpw" "notapassword"}";
                };
              };
            };
            "olcDatabase={2}monitor".attrs = {
              objectClass = [ "olcDatabaseConfig" ];
              olcDatabase = "{2}monitor";
              olcAccess = [ "to dn.subtree=cn=monitor by users read" ];
            };
          };
          declarativeContents."dc=example" = ''
            dn: dc=example
            objectClass: domain
            dc: example

            dn: ou=users,dc=example
            objectClass: organizationalUnit
            ou: users
          '';
        };
      };
      exporterTest = ''
        wait_for_unit("prometheus-openldap-exporter.service")
        wait_for_open_port(389)
        wait_for_open_port(9330)
        wait_until_succeeds(
            "curl -sSf http://localhost:9330/metrics | grep 'openldap_scrape{result=\"ok\"} 1'"
        )
      '';
    };

    openvpn = {
      exporterConfig = {
        enable = true;
        group = "openvpn";
        statusPaths = [ "/run/openvpn-test" ];
      };
      metricProvider = {
        users.groups.openvpn = { };
        services.openvpn.servers.test = {
          config = ''
            dev tun
            status /run/openvpn-test
            status-version 3
          '';
          up = "chmod g+r /run/openvpn-test";
        };
        systemd.services."openvpn-test".serviceConfig.Group = "openvpn";
      };
      exporterTest = ''
        wait_for_unit("openvpn-test.service")
        wait_for_unit("prometheus-openvpn-exporter.service")
        succeed("curl -sSf http://localhost:9176/metrics | grep 'openvpn_up{.*} 1'")
      '';
    };

    php-fpm = {
      nodeName = "php_fpm";
      exporterConfig = {
        enable = true;
        environmentFile = pkgs.writeTextFile {
          name = "/tmp/prometheus-php-fpm-exporter.env";
          text = ''
            PHP_FPM_SCRAPE_URI="tcp://127.0.0.1:9000/status"
          '';
        };
      };
      metricProvider = {
        users.users."php-fpm-exporter" = {
          isSystemUser = true;
          group  = "php-fpm-exporter";
        };
        users.groups."php-fpm-exporter" = {};
        services.phpfpm.pools."php-fpm-exporter" = {
          user = "php-fpm-exporter";
          group = "php-fpm-exporter";
          settings = {
            "pm" = "dynamic";
            "pm.max_children" = 32;
            "pm.max_requests" = 500;
            "pm.start_servers" = 2;
            "pm.min_spare_servers" = 2;
            "pm.max_spare_servers" = 5;
            "pm.status_path" = "/status";
            "listen" = "127.0.0.1:9000";
            "listen.allowed_clients" = "127.0.0.1";
          };
          phpEnv."PATH" = makeBinPath [ pkgs.php ];
        };
      };
      exporterTest = ''
        wait_for_unit("phpfpm-php-fpm-exporter.service")
        wait_for_unit("prometheus-php-fpm-exporter.service")
        succeed("curl -sSf http://localhost:9253/metrics | grep 'phpfpm_up{.*} 1'")
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
        wait_for_file("/var/lib/postfix/queue/public/showq")
        wait_for_open_port(9154)
        wait_until_succeeds(
            "curl -sSf http://localhost:9154/metrics | grep 'postfix_up{path=\"/var/lib/postfix/queue/public/showq\"} 1'"
        )
        succeed(
            "curl -sSf http://localhost:9154/metrics | grep 'postfix_smtpd_connects_total 0'"
        )
        succeed("curl -sSf http://localhost:9154/metrics | grep 'postfix_up{.*} 1'")
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
            "curl -sSf http://localhost:9187/metrics | grep 'pg_exporter_last_scrape_error 0'"
        )
        succeed("curl -sSf http://localhost:9187/metrics | grep 'pg_up 1'")
        systemctl("stop postgresql.service")
        succeed(
            "curl -sSf http://localhost:9187/metrics | grep -v 'pg_exporter_last_scrape_error 0'"
        )
        succeed("curl -sSf http://localhost:9187/metrics | grep 'pg_up 0'")
        systemctl("start postgresql.service")
        wait_for_unit("postgresql.service")
        succeed(
            "curl -sSf http://localhost:9187/metrics | grep 'pg_exporter_last_scrape_error 0'"
        )
        succeed("curl -sSf http://localhost:9187/metrics | grep 'pg_up 1'")
      '';
    };

    process = {
      exporterConfig = {
        enable = true;
        settings.process_names = [
          # Remove nix store path from process name
          { name = "{{.Matches.Wrapped}} {{ .Matches.Args }}"; cmdline = [ "^/nix/store[^ ]*/(?P<Wrapped>[^ /]*) (?P<Args>.*)" ]; }
        ];
      };
      exporterTest = ''
        wait_for_unit("prometheus-process-exporter.service")
        wait_for_open_port(9256)
        wait_until_succeeds(
            "curl -sSf localhost:9256/metrics | grep -q '{}'".format(
                'namedprocess_namegroup_cpu_seconds_total{groupname="process-exporter '
            )
        )
      '';
    };

    pve = let
      pveExporterEnvFile = pkgs.writeTextFile {
        name = "pve.env";
        text = ''
          PVE_USER="test_user@pam"
          PVE_PASSWORD="hunter3"
          PVE_VERIFY_SSL="false"
        '';
      };
    in {
      exporterConfig = {
        enable = true;
        environmentFile = pveExporterEnvFile;
      };
      exporterTest = ''
        wait_for_unit("prometheus-pve-exporter.service")
        wait_for_open_port(9221)
        wait_until_succeeds("curl localhost:9221")
      '';
    };

    py-air-control = {
      nodeName = "py_air_control";
      exporterConfig = {
        enable = true;
        deviceHostname = "127.0.0.1";
      };
      exporterTest = ''
        wait_for_unit("prometheus-py-air-control-exporter.service")
        wait_for_open_port(9896)
        succeed(
            "curl -sSf http://localhost:9896/metrics | grep 'py_air_control_sampling_error_total'"
        )
      '';
    };

    redis = {
      exporterConfig = {
        enable = true;
      };
      metricProvider.services.redis.servers."".enable = true;
      exporterTest = ''
        wait_for_unit("redis.service")
        wait_for_unit("prometheus-redis-exporter.service")
        wait_for_open_port(6379)
        wait_for_open_port(9121)
        wait_until_succeeds("curl -sSf localhost:9121/metrics | grep 'redis_up 1'")
      '';
    };

    rspamd = {
      exporterConfig = {
        enable = true;
      };
      metricProvider = {
        services.rspamd.enable = true;
      };
      exporterTest = ''
        wait_for_unit("rspamd.service")
        wait_for_unit("prometheus-rspamd-exporter.service")
        wait_for_open_port(11334)
        wait_for_open_port(7980)
        wait_until_succeeds(
            "curl -sSf 'localhost:7980/probe?target=http://localhost:11334/stat' | grep 'rspamd_scanned{host=\"rspamd\"} 0'"
        )
      '';
    };

    rtl_433 = {
      exporterConfig = {
        enable = true;
      };
      metricProvider = {
        # Mock rtl_433 binary to return a dummy metric stream.
        nixpkgs.overlays = [
          (self: super: {
            rtl_433 = self.runCommand "rtl_433" { } ''
              mkdir -p "$out/bin"
              cat <<EOF > "$out/bin/rtl_433"
              #!/bin/sh
              while true; do
                printf '{"time" : "2020-04-26 13:37:42", "model" : "zopieux", "id" : 55, "channel" : 3, "temperature_C" : 18.000}\n'
                sleep 4
              done
              EOF
              chmod +x "$out/bin/rtl_433"
            '';
          })
        ];
      };
      exporterTest = ''
        wait_for_unit("prometheus-rtl_433-exporter.service")
        wait_for_open_port(9550)
        wait_until_succeeds(
            "curl -sSf localhost:9550/metrics | grep '{}'".format(
                'rtl_433_temperature_celsius{channel="3",id="55",location="",model="zopieux"} 18'
            )
        )
      '';
    };

    sabnzbd = {
      exporterConfig = {
        enable = true;
        servers = [{
          baseUrl = "http://localhost:8080";
          apiKeyFile = "/var/sabnzbd-apikey";
        }];
      };

      metricProvider = {
        services.sabnzbd.enable = true;

        # unrar is required for sabnzbd
        nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [ "unrar" ];

        # extract the generated api key before starting
        systemd.services.sabnzbd-apikey = {
          requires = [ "sabnzbd.service" ];
          after = [ "sabnzbd.service" ];
          requiredBy = [ "prometheus-sabnzbd-exporter.service" ];
          before = [ "prometheus-sabnzbd-exporter.service" ];
          script = ''
            grep -Po '^api_key = \K.+' /var/lib/sabnzbd/sabnzbd.ini > /var/sabnzbd-apikey
          '';
        };
      };

      exporterTest = ''
        wait_for_unit("sabnzbd.service")
        wait_for_unit("prometheus-sabnzbd-exporter.service")
        wait_for_open_port(8080)
        wait_for_open_port(9387)
        wait_until_succeeds(
            "curl -sSf 'localhost:9387/metrics' | grep 'sabnzbd_queue_size{sabnzbd_instance=\"http://localhost:8080\"} 0.0'"
        )
      '';
    };

    scaphandre = {
      exporterConfig = {
        enable = true;
      };
      metricProvider = {
        boot.kernelModules = [ "intel_rapl_common" ];
      };
      exporterTest = ''
        wait_for_unit("prometheus-scaphandre-exporter.service")
        wait_for_open_port(8080)
        wait_until_succeeds(
            "curl -sSf 'localhost:8080/metrics'"
        )
      '';
    };

    shelly = {
      exporterConfig = {
        enable = true;
        metrics-file = "${pkgs.writeText "test.json" ''{}''}";
      };
      exporterTest = ''
        wait_for_unit("prometheus-shelly-exporter.service")
        wait_for_open_port(9784)
        wait_until_succeeds(
            "curl -sSf 'localhost:9784/metrics'"
        )
      '';
    };

    script = {
      exporterConfig = {
        enable = true;
        settings.scripts = [
          { name = "success"; script = "sleep 1"; }
        ];
      };
      exporterTest = ''
        wait_for_unit("prometheus-script-exporter.service")
        wait_for_open_port(9172)
        wait_until_succeeds(
            "curl -sSf 'localhost:9172/probe?name=success' | grep -q '{}'".format(
                'script_success{script="success"} 1'
            )
        )
      '';
    };

    smartctl = {
      exporterConfig = {
        enable = true;
        devices = [
          "/dev/vda"
        ];
      };
      exporterTest = ''
        wait_until_succeeds(
            'journalctl -eu prometheus-smartctl-exporter.service -o cat | grep "Unable to detect device type"'
        )
      '';
    };

    smokeping = {
      exporterConfig = {
        enable = true;
        hosts = [ "127.0.0.1" ];
      };
      exporterTest = ''
        wait_for_unit("prometheus-smokeping-exporter.service")
        wait_for_open_port(9374)
        wait_until_succeeds(
            "curl -sSf localhost:9374/metrics | grep '{}' | grep -v ' 0$'".format(
                'smokeping_requests_total{host="127.0.0.1",ip="127.0.0.1"} '
            )
        )
        wait_until_succeeds(
            "curl -sSf localhost:9374/metrics | grep '{}'".format(
                'smokeping_response_ttl{host="127.0.0.1",ip="127.0.0.1"}'
            )
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
        succeed("curl -sSf localhost:9116/metrics | grep 'snmp_request_errors_total 0'")
      '';
    };

    sql = {
      exporterConfig = {
        configuration.jobs.points = {
          interval = "1m";
          connections = [
            "postgres://prometheus-sql-exporter@/data?host=/run/postgresql&sslmode=disable"
          ];
          queries = {
            points = {
              labels = [ "name" ];
              help = "Amount of points accumulated per person";
              values = [ "amount" ];
              query = "SELECT SUM(amount) as amount, name FROM points GROUP BY name";
            };
          };
        };
        enable = true;
        user = "prometheus-sql-exporter";
      };
      metricProvider = {
        services.postgresql = {
          enable = true;
          initialScript = builtins.toFile "init.sql" ''
            CREATE DATABASE data;
            \c data;
            CREATE TABLE points (amount INT, name TEXT);
            INSERT INTO points(amount, name) VALUES (1, 'jack');
            INSERT INTO points(amount, name) VALUES (2, 'jill');
            INSERT INTO points(amount, name) VALUES (3, 'jack');

            CREATE USER "prometheus-sql-exporter";
            GRANT ALL PRIVILEGES ON DATABASE data TO "prometheus-sql-exporter";
            GRANT SELECT ON points TO "prometheus-sql-exporter";
          '';
        };
        systemd.services.prometheus-sql-exporter.after = [ "postgresql.service" ];
      };
      exporterTest = ''
        wait_for_unit("prometheus-sql-exporter.service")
        wait_for_open_port(9237)
        succeed("curl http://localhost:9237/metrics | grep -c 'sql_points{' | grep 2")
      '';
    };

    statsd = {
      exporterConfig = {
        enable = true;
      };
      exporterTest = ''
        wait_for_unit("prometheus-statsd-exporter.service")
        wait_for_open_port(9102)
        succeed("curl http://localhost:9102/metrics | grep 'statsd_exporter_build_info{'")
        wait_until_succeeds(
          "echo 'test.udp:1|c' > /dev/udp/localhost/9125 && \
          curl http://localhost:9102/metrics | grep 'test_udp 1'",
          timeout=10
        )
        wait_until_succeeds(
          "echo 'test.tcp:1|c' > /dev/tcp/localhost/9125 && \
          curl http://localhost:9102/metrics | grep 'test_tcp 1'",
          timeout=10
        )
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
        succeed("curl -sSf localhost:9239/metrics | grep 'surfboard_up 1'")
      '';
    };

    systemd = {
      exporterConfig = {
        enable = true;

        extraFlags = [
          "--systemd.collector.enable-restart-count"
        ];
      };
      metricProvider = { };
      exporterTest = ''
        wait_for_unit("prometheus-systemd-exporter.service")
        wait_for_open_port(9558)
        wait_until_succeeds(
            "curl -sSf localhost:9558/metrics | grep '{}'".format(
                'systemd_unit_state{name="basic.target",state="active",type="target"} 1'
            )
        )
        succeed(
            "curl -sSf localhost:9558/metrics | grep '{}'".format(
                'systemd_service_restart_total{name="prometheus-systemd-exporter.service"} 0'
            )
        )
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
        services.tor.settings.ControlPort = 9051;
      };
      exporterTest = ''
        wait_for_unit("tor.service")
        wait_for_open_port(9051)
        wait_for_unit("prometheus-tor-exporter.service")
        wait_for_open_port(9130)
        succeed("curl -sSf localhost:9130/metrics | grep 'tor_version{.\\+} 1'")
      '';
    };

    unpoller = {
      nodeName = "unpoller";
      exporterConfig.enable = true;
      exporterConfig.controllers = [{ }];
      exporterTest = ''
        wait_until_succeeds(
            'journalctl -eu prometheus-unpoller-exporter.service -o cat | grep "Connection Error"'
        )
      '';
    };

    unbound = {
      exporterConfig = {
        enable = true;
        unbound.host = "unix:///run/unbound/unbound.ctl";
      };
      metricProvider = {
        services.unbound = {
          enable = true;
          localControlSocketPath = "/run/unbound/unbound.ctl";
        };
        systemd.services.prometheus-unbound-exporter.serviceConfig = {
          SupplementaryGroups = [ "unbound" ];
        };
      };
      exporterTest = ''
        wait_for_unit("unbound.service")
        wait_for_unit("prometheus-unbound-exporter.service")
        wait_for_open_port(9167)
        wait_until_succeeds("curl -sSf localhost:9167/metrics | grep 'unbound_up 1'")
      '';
    };

    v2ray = {
      exporterConfig = {
        enable = true;
      };

      metricProvider = {
        systemd.services.prometheus-nginx-exporter.after = [ "v2ray.service" ];
        services.v2ray = {
          enable = true;
          config = {
            stats = {};
            api = {
              tag = "api";
              services = [ "StatsService" ];
            };
            inbounds = [
              {
                port = 1080;
                listen = "127.0.0.1";
                protocol = "http";
              }
              {
                listen = "127.0.0.1";
                port = 54321;
                protocol = "dokodemo-door";
                settings = { address = "127.0.0.1"; };
                tag = "api";
              }
            ];
            outbounds = [
              {
                protocol = "freedom";
              }
              {
                protocol = "freedom";
                settings = {};
                tag = "api";
              }
            ];
            routing = {
              strategy = "rules";
              settings = {
                rules = [
                  {
                    inboundTag = [ "api" ];
                    outboundTag = "api";
                    type = "field";
                  }
                ];
              };
            };
          };
        };
      };
      exporterTest = ''
        wait_for_unit("prometheus-v2ray-exporter.service")
        wait_for_open_port(9299)
        succeed("curl -sSf localhost:9299/scrape | grep 'v2ray_up 1'")
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
        succeed("curl -sSf http://localhost:9131/metrics | grep 'varnish_up 1'")
      '';
    };

    wireguard = let
      snakeoil = import ./wireguard/snakeoil-keys.nix;
      publicKeyWithoutNewlines = replaceStrings [ "\n" ] [ "" ] snakeoil.peer1.publicKey;
    in
      {
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
              "curl -sSf http://localhost:9586/metrics | grep '${publicKeyWithoutNewlines}'"
          )
        '';
      };

    zfs = {
      exporterConfig = {
        enable = true;
      };
      metricProvider = {
        boot.supportedFilesystems = [ "zfs" ];
        networking.hostId = "7327ded7";
      };
      exporterTest = ''
        wait_for_unit("prometheus-zfs-exporter.service")
        wait_for_unit("zfs.target")
        wait_for_open_port(9134)
        wait_until_succeeds("curl -f localhost:9134/metrics | grep 'zfs_scrape_collector_success{.*} 1'")
      '';
    };
  };
in
mapAttrs
  (exporter: testConfig: (makeTest (
    let
      nodeName = testConfig.nodeName or exporter;

    in
    {
      name = "prometheus-${exporter}-exporter";

      nodes.${nodeName} = mkMerge [{
        services.prometheus.exporters.${exporter} = testConfig.exporterConfig;
      } testConfig.metricProvider or { }];

      testScript = ''
        ${nodeName}.start()
        ${concatStringsSep "\n" (map (line:
          if (builtins.substring 0 1 line == " " || builtins.substring 0 1 line == ")")
          then line
          else "${nodeName}.${line}"
        ) (splitString "\n" (removeSuffix "\n" testConfig.exporterTest)))}
        ${nodeName}.shutdown()
      '';

      meta = with maintainers; {
        maintainers = [ willibutz ];
      };
    }
  )))
  exporterTests
