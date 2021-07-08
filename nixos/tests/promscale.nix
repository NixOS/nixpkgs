import ./make-test-python.nix (
  { pkgs, lib, ... }:

    let

      # Testing non default values where possible - do not use these values in production
      listen-address = "[::1]";
      listen-port = 9202;
      async-acks = true;
      install-timescaledb = true;
      use-schema-version-lease = true;
      web-telemetry-path = "/metric";
      db-connect-retries = 23;
      db-connections-max = 20;
      db-host = "::1";
      db-name = "timescaledb";
      db-password = "snakeOilPassword";
      db-port = 5433;
      db-ssl-mode = "prefer";
      db-user = "postgres";
      labels-cache-size = 1234;
      log-level = "info";
      metrics-cache-size = 1234;
      migrate = "true";
      scheduled-election-interval = "50s";
      tput-report = 1234;
      leader-election-pg-advisory-lock-id = 2;
      leader-election-pg-advisory-lock-prometheus-timeout = "60s";
      # BROKEN: If leader-election is set, database command line args are neglected, only envvars are in effect.
      leader-election-rest = false;

    in

      {

        name = "promscale";

        meta.maintainers = with lib.maintainers; [ _0x4A6F ];

        nodes = {

          postgresql_11 = {
            services.promscale.enable = true;
            services.promscale.asyncAcks = async-acks;
            services.promscale.installTimescaledb = install-timescaledb;
            services.promscale.useSchemaVersionLease = use-schema-version-lease;
            services.promscale.web.listenAddress = listen-address;
            services.promscale.web.listenPort = listen-port;
            services.promscale.web.telemetryPath = web-telemetry-path;
            services.promscale.database.connectRetries = db-connect-retries;
            services.promscale.database.connectionsMax = db-connections-max;
            services.promscale.database.host = db-host;
            services.promscale.database.name = db-name;
            services.promscale.database.passwordFile = "${pkgs.writeText "promscale.db-passwordFile" db-password}";
            services.promscale.database.port = db-port;
            services.promscale.database.sslMode = db-ssl-mode;
            services.promscale.database.user = db-user;
            services.promscale.labelsCacheSize = labels-cache-size;
            services.promscale.logLevel = log-level;
            services.promscale.metricsCacheSize = metrics-cache-size;
            services.promscale.migrate = migrate;
            services.promscale.tputReport = tput-report;
            #services.promscale.leaderElection.pg.advisoryLockId = leader-election-pg-advisory-lock-id;
            #services.promscale.leaderElection.pg.advisoryLockPrometheusTimeout = leader-election-pg-advisory-lock-prometheus-timeout;
            services.promscale.leaderElection.rest = leader-election-rest;
            #services.promscale.leaderElection.scheduledElectionInterval = scheduled-election-interval;
            # for future command line args
            services.promscale.extraOptions = [
              "-db-writer-connection-concurrency 1"
            # "-web-cors-origin .*" # corsOrigin:0xc0002da140
            # "-web-cors-origin example.com.*" # corsOrigin:0xc00016df40
            # "-web-cors-origin example.com/public/.*" # corsOrigin:0xc00016dea0
            ];
            services.postgresql = {
              authentication = pkgs.lib.mkOverride 10 ''
                local all all trust
                host all all ::1/128 trust
                host all all 127.0.0.1/32 trust
              '';
              enable = true;
              package = pkgs.postgresql_11;
              extraPlugins = with pkgs.postgresql11Packages; [ timescaledb ];
              settings = {
                shared_preload_libraries = "timescaledb";
              };
              ensureDatabases = [ db-name ];
              ensureUsers = [
                {
                  name = db-user;
                  ensurePermissions = {
                    "DATABASE ${db-name}" = "ALL PRIVILEGES";
                  };
                }
              ];
              port = db-port;
            };
            environment.systemPackages = with pkgs; [
              timescaledb-tune
            ];
            #systemd.services.timescale-prometheus = {
            #  before = [ "prometheus.service" ];
            #};
            #services.prometheus = {
            #  enable = true;
            #  listenAddress = "127.0.0.1";
            #  port = 9090;
            #  remoteWrite = [
            #    {
            #      url = "http://${listen-address}:${toString listen-port}/write";
            #    }
            #  ];
            #  remoteRead = [
            #    {
            #      url = "http://${listen-address}:${toString listen-port}/read";
            #    }
            #  ];
            #  scrapeConfigs = [
            #    {
            #      job_name = "prometheus";
            #      static_configs = [
            #        {
            #          targets = [ "localhost:9090" ];
            #          labels = { instance = "postgresql_11"; };
            #        }
            #      ];
            #    }
            #  ];
            #};
          };

        };

        testScript = ''
          start_all()

          with subtest("postgresql_11-promscale-metrics"):
              postgresql_11.wait_for_open_port(${toString listen-port})
              postgresql_11.fail("ps auxwww | grep ${db-password} | grep -v grep")
              postgresql_11.succeed(
                  "curl -s --fail http://${listen-address}:${toString listen-port}${web-telemetry-path} | grep -qi go_gc_duration_seconds"
              )
        '';

      }

)
