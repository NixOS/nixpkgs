{
  config,
  pkgs,
  lib,
  ...
}:
let

  cfg = config.services.hydra;
  queueRunnerCfg = cfg.queueRunner;

  toml = pkgs.formats.toml { };

  baseDir = "/var/lib/hydra";

  hydraConf = pkgs.writeScript "hydra.conf" cfg.extraConfig;

  hydraEnv = {
    HYDRA_DATABASE_URL = cfg.dbUrl;
    HYDRA_CONFIG = "${baseDir}/hydra.conf";
    HYDRA_DATA = "${baseDir}";
  };

  # Appends `application_name` so queries can be attributed in pg_stat_activity.
  # `%` is doubled because the value lands in systemd `Environment=`, where the
  # percent-encoded socket path (`%2Frun%2Fpostgresql`) would be parsed as a
  # specifier.
  dbUrlWithAppName =
    name:
    lib.replaceStrings [ "%" ] [ "%%" ] (
      cfg.dbUrl + (if lib.hasInfix "?" cfg.dbUrl then "&" else "?") + "application_name=${name}"
    );

  env = {
    NIX_REMOTE = "daemon";
    PGPASSFILE = "${baseDir}/pgpass";
  }
  // lib.optionalAttrs (cfg.smtpHost != null) {
    EMAIL_SENDER_TRANSPORT = "SMTP";
    EMAIL_SENDER_TRANSPORT_host = cfg.smtpHost;
  }
  // hydraEnv
  // cfg.extraEnv;

  serverEnv =
    env
    // {
      HYDRA_TRACKER = cfg.tracker;
      XDG_CACHE_HOME = "${baseDir}/www/.cache";
      COLUMNS = "80";
      PGPASSFILE = "${baseDir}/pgpass-www"; # grrr
    }
    // (lib.optionalAttrs cfg.debugServer { DBIC_TRACE = "1"; });

  localDbUrl = "postgres://hydra@%2Frun%2Fpostgresql:5432/hydra";

  haveLocalDB = cfg.dbUrl == localDbUrl;

  hydra-package =
    let
      makeWrapperArgs = lib.concatStringsSep " " (
        lib.mapAttrsToList (key: value: "--set-default \"${key}\" \"${value}\"") hydraEnv
      );
    in
    pkgs.buildEnv rec {
      name = "hydra-env";
      nativeBuildInputs = [ pkgs.makeWrapper ];
      paths = [ cfg.package ];

      postBuild = ''
        if [ -L "$out/bin" ]; then
            unlink "$out/bin"
        fi
        mkdir -p "$out/bin"

        for path in ${lib.concatStringsSep " " paths}; do
          if [ -d "$path/bin" ]; then
            cd "$path/bin"
            for prg in *; do
              if [ -f "$prg" ]; then
                rm -f "$out/bin/$prg"
                if [ -x "$prg" ]; then
                  makeWrapper "$path/bin/$prg" "$out/bin/$prg" ${makeWrapperArgs}
                fi
              fi
            done
          fi
        done
      '';
    };

in

{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "hydra" "dbi" ] ''
      Use `services.hydra.dbUrl`, which takes a postgres:// URL instead of a DBI string.
    '')
    (lib.mkRemovedOptionModule [ "services" "hydra" "buildMachinesFiles" ] ''
      The queue runner no longer reads Nix build machines files. Builders now
      connect to it via gRPC, see `services.hydra-builder`.
    '')
  ];

  ###### interface
  options = {

    services.hydra = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to run Hydra services.
        '';
      };

      dbUrl = lib.mkOption {
        type = lib.types.str;
        default = localDbUrl;
        example = "postgres://foo@postgres.example.org:5432/hydra";
        description = ''
          `postgres://` URL of the Hydra database.

          An `application_name` query parameter is appended per service
          (e.g. `hydra-evaluator`), so do not set one here.
        '';
      };

      package = lib.mkPackageOption pkgs "hydra" { };

      evaluatorPackage = lib.mkPackageOption pkgs "hydra-evaluator" { };

      evaluatorSettings = lib.mkOption {
        description = ''
          Settings for the evaluator, written to
          {file}`/etc/hydra/evaluator.toml`.
        '';
        default = { };
        type = lib.types.submodule {
          freeformType = toml.type;
          options = {
            max_concurrent_evals = lib.mkOption {
              type = lib.types.ints.positive;
              default = 4;
              description = "How many jobsets to evaluate at once.";
            };
          };
        };
      };

      ws = {
        enable =
          lib.mkEnableOption "the WebSocket server streaming live build logs to the web interface"
          // {
            default = true;
            example = false;
          };

        package = lib.mkPackageOption pkgs "hydra-ws" { };

        settings = lib.mkOption {
          description = ''
            Settings for the WebSocket server, written to
            {file}`/etc/hydra/ws.toml`.
          '';
          default = { };
          type = lib.types.submodule {
            options = {
              dbUrl = lib.mkOption {
                type = lib.types.singleLineStr;
                default = cfg.dbUrl;
                defaultText = lib.literalExpression "config.services.hydra.dbUrl";
                description = "PostgreSQL database URL.";
              };

              maxDbConnections = lib.mkOption {
                type = lib.types.ints.positive;
                default = 128;
                description = "Maximum number of PostgreSQL connections.";
              };

              idleGrace = lib.mkOption {
                type = lib.types.int;
                default = 128;
                description = "Idle grace period in seconds before a log tail is stopped.";
              };

              hydraDataDir = lib.mkOption {
                type = lib.types.path;
                default = baseDir;
                defaultText = lib.literalExpression ''"${baseDir}"'';
                description = "Hydra data directory.";
              };
            };
          };
        };

        bind = {
          address = lib.mkOption {
            type = lib.types.singleLineStr;
            default = "[::1]";
            description = "Address the WebSocket listener binds to.";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 9283;
            description = "Port the WebSocket listener binds to.";
          };
        };
      };

      hydraURL = lib.mkOption {
        type = lib.types.str;
        description = ''
          The base URL for the Hydra webserver instance. Used for links in emails.
        '';
      };

      listenHost = lib.mkOption {
        type = lib.types.str;
        default = "*";
        example = "localhost";
        description = ''
          The hostname or address to listen on or `*` to listen
          on all interfaces.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = ''
          TCP port the web server should listen to.
        '';
      };

      minimumDiskFree = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = ''
          Threshold of minimum disk space (GiB) to determine if the queue runner should run or not.
        '';
      };

      minimumDiskFreeEvaluator = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = ''
          Threshold of minimum disk space (GiB) to determine if the evaluator should run or not.
        '';
      };

      notificationSender = lib.mkOption {
        type = lib.types.str;
        description = ''
          Sender email address used for email notifications.
        '';
      };

      smtpHost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "localhost";
        description = ''
          Hostname of the SMTP server to use to send email.
        '';
      };

      tracker = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          Piece of HTML that is included on all pages.
        '';
      };

      logo = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to a file containing the logo of your Hydra instance.
        '';
      };

      debugServer = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to run the server in debug mode.";
      };

      maxServers = lib.mkOption {
        type = lib.types.int;
        default = 25;
        description = "Maximum number of starman workers to spawn.";
      };

      minSpareServers = lib.mkOption {
        type = lib.types.int;
        default = 4;
        description = "Minimum number of spare starman workers to keep.";
      };

      maxSpareServers = lib.mkOption {
        type = lib.types.int;
        default = 5;
        description = "Maximum number of spare starman workers to keep.";
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        description = "Extra lines for the Hydra configuration.";
      };

      extraEnv = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Extra environment variables for Hydra.";
      };

      gcRootsDir = lib.mkOption {
        type = lib.types.path;
        default = "/nix/var/nix/gcroots/hydra";
        description = "Directory that holds Hydra garbage collector roots.";
      };

      useSubstitutes = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to use binary caches for downloading store paths. Note that
          binary substitutions trigger (a potentially large number of) additional
          HTTP requests that slow down the queue monitor thread significantly.
          Also, this Hydra instance will serve those downloaded store paths to
          its users with its own signature attached as if it had built them
          itself, so don't enable this feature unless your active binary caches
          are absolute trustworthy.
        '';
      };

      queueRunner = {
        package = lib.mkPackageOption pkgs "hydra-queue-runner" { };

        settings = lib.mkOption {
          description = ''
            Reloadable settings for the queue runner, written to
            {file}`/etc/hydra/queue-runner.toml`.
          '';
          default = { };
          type = lib.types.submodule {
            options = {
              hydraDataDir = lib.mkOption {
                type = lib.types.path;
                default = baseDir;
                defaultText = lib.literalExpression ''"${baseDir}"'';
                description = "Hydra data directory.";
              };

              dbUrl = lib.mkOption {
                type = lib.types.singleLineStr;
                default = cfg.dbUrl;
                defaultText = lib.literalExpression "config.services.hydra.dbUrl";
                description = "PostgreSQL database URL.";
              };

              maxDbConnections = lib.mkOption {
                type = lib.types.ints.positive;
                default = 128;
                description = "Maximum number of PostgreSQL connections.";
              };

              machineSortFn = lib.mkOption {
                type = lib.types.enum [
                  "SpeedFactorOnly"
                  "CpuCoreCountWithSpeedFactor"
                  "BogomipsWithSpeedFactor"
                ];
                default = "SpeedFactorOnly";
                description = "Function used to sort machines.";
              };

              machineFreeFn = lib.mkOption {
                type = lib.types.enum [
                  "Dynamic"
                  "DynamicWithMaxJobLimit"
                  "Static"
                ];
                default = "Static";
                description = ''Function used to determine "idle" machines.'';
              };

              stepSortFn = lib.mkOption {
                type = lib.types.enum [
                  "Legacy"
                  "WithRdeps"
                  "WithCriticalPath"
                ];
                default = "WithRdeps";
                description = "Function used to sort steps.";
              };

              dispatchTriggerTimerInS = lib.mkOption {
                type = lib.types.int;
                default = 120;
                description = ''
                  Interval in seconds at which the dispatcher is triggered. A
                  value <= 0 disables the timer, leaving the dispatcher to be
                  triggered by queue changes only.
                '';
              };

              queueTriggerTimerInS = lib.mkOption {
                type = lib.types.int;
                default = -1;
                description = ''
                  Interval in seconds at which the queue is triggered. A value
                  <= 0 disables the timer, leaving the queue to be triggered by
                  PostgreSQL notifications only.
                '';
              };

              remoteStoreAddr = lib.mkOption {
                type = lib.types.listOf lib.types.singleLineStr;
                default = [ ];
                description = "Remote store addresses.";
              };

              useSubstitutes = lib.mkOption {
                type = lib.types.bool;
                default = cfg.useSubstitutes;
                defaultText = lib.literalExpression "config.services.hydra.useSubstitutes";
                description = "Whether to substitute paths instead of building them.";
              };

              rootsDir = lib.mkOption {
                type = lib.types.nullOr lib.types.path;
                default = cfg.gcRootsDir;
                defaultText = lib.literalExpression "config.services.hydra.gcRootsDir";
                description = "Directory holding the garbage collector roots.";
              };

              maxRetries = lib.mkOption {
                type = lib.types.ints.positive;
                default = 5;
                description = "Maximum number of retries for a build step.";
              };

              retryInterval = lib.mkOption {
                type = lib.types.ints.positive;
                default = 60;
                description = "Interval in seconds after which a step may be retried.";
              };

              retryBackoff = lib.mkOption {
                type = lib.types.float;
                default = 3.0;
                description = "Additional backoff on top of {option}`retryInterval`.";
              };

              maxUnsupportedTimeInS = lib.mkOption {
                type = lib.types.ints.unsigned;
                default = 120;
                description = "Time in seconds after which unsupported steps are aborted.";
              };

              stopQueueRunAfterInS = lib.mkOption {
                type = lib.types.int;
                default = 60;
                description = ''
                  Seconds after which a queue run is interrupted early. A value
                  <= 0 lets queue runs go on for as long as they need.
                '';
              };

              maxConcurrentDownloads = lib.mkOption {
                type = lib.types.ints.positive;
                default = 5;
                description = ''
                  Maximum number of concurrent downloads per build. Raising this
                  raises the queue runner's memory usage.
                '';
              };

              concurrentUploadLimit = lib.mkOption {
                type = lib.types.ints.positive;
                default = 5;
                description = "Maximum number of concurrent uploads to S3.";
              };

              tokenPaths = lib.mkOption {
                type = lib.types.nullOr (lib.types.listOf lib.types.path);
                default = null;
                description = "Paths of the accepted authentication tokens.";
              };

              enableFodChecker = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                  Whether to enable the fixed-output derivation checker, which
                  collects FODs in a separate queue and schedules them on
                  machines advertising the mandatory `FOD` feature.
                '';
              };

              usePresignedUploads = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                  Whether builders upload to S3 themselves instead of the queue
                  runner. Requires an S3 remote store as well as substitution on
                  the builders, see {option}`forcedSubstituters`.
                '';
              };

              overflowStore = lib.mkOption {
                default = null;
                description = ''
                  Overflow S3 store. Steps referenced only by the listed jobsets
                  are uploaded there instead of to the default store.
                '';
                type = lib.types.nullOr (
                  lib.types.submodule {
                    options = {
                      store = lib.mkOption {
                        type = lib.types.singleLineStr;
                        example = "s3://overflow?region=eu-west-1";
                        description = "S3 store URI of the overflow bucket.";
                      };

                      jobsets = lib.mkOption {
                        type = lib.types.listOf lib.types.singleLineStr;
                        default = [ ];
                        example = [ "nixpkgs:trunk" ];
                        description = "Jobsets (`project:jobset`) whose exclusive steps go to the overflow store.";
                      };
                    };
                  }
                );
              };

              forcedSubstituters = lib.mkOption {
                type = lib.types.listOf lib.types.singleLineStr;
                default = [ ];
                description = ''
                  Substituters every builder is required to have. Builders that
                  do not enable `useSubstitutes` with these substituters are
                  rejected.
                '';
              };

              maxOutputSize = lib.mkOption {
                type = lib.types.ints.unsigned;
                default = 0;
                description = ''
                  Per-output NAR size limit in bytes. Builds exceeding it fail
                  with `NarSizeLimitExceeded`. 0 disables the check.
                '';
              };

              maxSilentTime = lib.mkOption {
                type = lib.types.ints.unsigned;
                default = 3600;
                description = ''
                  Default maximum silent time in seconds for builds without
                  `meta.maxSilent`. Also used as a floor for dependency-only
                  steps.
                '';
              };

              buildTimeout = lib.mkOption {
                type = lib.types.ints.unsigned;
                default = 36000;
                description = ''
                  Default build timeout in seconds for builds without
                  `meta.timeout`. Also used as a floor for dependency-only
                  steps.
                '';
              };

              maxLogSize = lib.mkOption {
                type = lib.types.ints.unsigned;
                default = 64 * 1024 * 1024;
                description = ''
                  Maximum build log size in bytes before a build fails with
                  `LogLimitExceeded`.
                '';
              };
            };
          };
        };

        grpc = {
          address = lib.mkOption {
            type = lib.types.singleLineStr;
            default = "[::1]";
            description = ''
              Address the gRPC listener binds to. Must be reachable from
              machines running {option}`services.hydra-builder`.
            '';
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 50051;
            description = "Port the gRPC listener binds to.";
          };
        };

        rest = {
          address = lib.mkOption {
            type = lib.types.singleLineStr;
            default = "[::1]";
            description = "Address the REST listener binds to.";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 8080;
            description = "Port the REST listener binds to.";
          };
        };

        mtls = lib.mkOption {
          default = null;
          description = "mTLS material used to authenticate builders.";
          type = lib.types.nullOr (
            lib.types.submodule {
              options = {
                serverCertPath = lib.mkOption {
                  type = lib.types.path;
                  description = "Server certificate path.";
                };

                serverKeyPath = lib.mkOption {
                  type = lib.types.path;
                  description = "Server key path.";
                };

                clientCaCertPath = lib.mkOption {
                  type = lib.types.path;
                  description = "Client CA certificate path.";
                };
              };
            }
          );
        };

        awsCredentialsFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = ''
            Path to an AWS credentials file, exported as
            `AWS_SHARED_CREDENTIALS_FILE` to the queue runner.
          '';
        };
      };
    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.maxServers != 0 && cfg.maxSpareServers != 0 && cfg.minSpareServers != 0;
        message = "services.hydra.{minSpareServers,maxSpareServers,minSpareServers} cannot be 0";
      }
      {
        assertion = cfg.minSpareServers < cfg.maxSpareServers;
        message = "services.hydra.minSpareServers cannot be bigger than services.hydra.maxSpareServers";
      }
    ];

    users.groups.hydra = {
      gid = config.ids.gids.hydra;
    };

    users.users.hydra = {
      description = "Hydra";
      group = "hydra";
      # We don't enable `createHome` here because the creation of the home directory is handled by the hydra-init service below.
      home = baseDir;
      useDefaultShell = true;
      uid = config.ids.uids.hydra;
    };

    users.users.hydra-queue-runner = {
      description = "Hydra queue runner";
      group = "hydra";
      useDefaultShell = true;
      home = "${baseDir}/queue-runner";
      uid = config.ids.uids.hydra-queue-runner;
    };

    users.users.hydra-ws = lib.mkIf cfg.ws.enable {
      description = "Hydra WebSocket server";
      group = "hydra";
      isSystemUser = true;
    };

    users.users.hydra-www = {
      description = "Hydra web server";
      group = "hydra";
      useDefaultShell = true;
      uid = config.ids.uids.hydra-www;
    };

    services.hydra.extraConfig = ''
      using_frontend_proxy = 1
      base_uri = ${cfg.hydraURL}
      notification_sender = ${cfg.notificationSender}
      max_servers = ${toString cfg.maxServers}
      ${lib.optionalString (cfg.logo != null) ''
        hydra_logo = ${cfg.logo}
      ''}
      gc_roots_dir = ${cfg.gcRootsDir}
      use-substitutes = ${if cfg.useSubstitutes then "1" else "0"}
    '';

    environment.systemPackages = [ hydra-package ];

    environment.variables = hydraEnv;

    nix.settings = lib.mkMerge [
      {
        keep-outputs = true;
        keep-derivations = true;
        trusted-users = [ "hydra-queue-runner" ];
      }

      (lib.mkIf (lib.versionOlder (lib.getVersion config.nix.package.out) "2.4pre") {
        # The default (`true') slows Nix down a lot since the build farm
        # has so many GC roots.
        gc-check-reachability = false;
      })
    ];

    systemd.slices.system-hydra = {
      description = "Hydra CI Server Slice";
      documentation = [
        "file://${cfg.package}/share/doc/hydra/index.html"
        "https://nixos.org/hydra/manual/"
      ];
    };

    systemd.services.hydra-init = {
      wantedBy = [ "multi-user.target" ];
      requires = lib.optional haveLocalDB "postgresql.target";
      after = lib.optional haveLocalDB "postgresql.target";
      environment = env // {
        HYDRA_DATABASE_URL = dbUrlWithAppName "hydra-init";
      };
      path = [ pkgs.util-linux ];
      preStart = ''
        mkdir -p ${baseDir}
        chown hydra:hydra ${baseDir}
        chmod 0750 ${baseDir}

        ln -sf ${hydraConf} ${baseDir}/hydra.conf

        mkdir -m 0700 ${baseDir}/www || true
        chown hydra-www:hydra ${baseDir}/www

        mkdir -m 0700 ${baseDir}/queue-runner || true
        mkdir -m 0750 ${baseDir}/build-logs || true
        mkdir -m 0750 ${baseDir}/runcommand-logs || true
        chown hydra-queue-runner:hydra \
          ${baseDir}/queue-runner \
          ${baseDir}/build-logs \
          ${baseDir}/runcommand-logs

        ${lib.optionalString haveLocalDB ''
          if ! [ -e ${baseDir}/.db-created ]; then
            runuser -u ${config.services.postgresql.superUser} ${config.services.postgresql.package}/bin/createuser hydra
            runuser -u ${config.services.postgresql.superUser} ${config.services.postgresql.package}/bin/createdb -- -O hydra hydra
            touch ${baseDir}/.db-created
          fi
          echo "create extension if not exists pg_trgm" | runuser -u ${config.services.postgresql.superUser} -- ${config.services.postgresql.package}/bin/psql hydra
        ''}

        if [ ! -e ${cfg.gcRootsDir} ]; then

          # Move legacy roots directory.
          if [ -e /nix/var/nix/gcroots/per-user/hydra/hydra-roots ]; then
            mv /nix/var/nix/gcroots/per-user/hydra/hydra-roots ${cfg.gcRootsDir}
          fi

          mkdir -p ${cfg.gcRootsDir}
        fi

        # Move legacy hydra-www roots.
        if [ -e /nix/var/nix/gcroots/per-user/hydra-www/hydra-roots ]; then
          find /nix/var/nix/gcroots/per-user/hydra-www/hydra-roots/ -type f -print0 \
            | xargs -0 -r mv -f -t ${cfg.gcRootsDir}/
          rmdir /nix/var/nix/gcroots/per-user/hydra-www/hydra-roots
        fi

        chown hydra:hydra ${cfg.gcRootsDir}
        chmod 2775 ${cfg.gcRootsDir}
      '';
      serviceConfig.ExecStart = "${hydra-package}/bin/hydra-init";
      serviceConfig.PermissionsStartOnly = true;
      serviceConfig.User = "hydra";
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
      serviceConfig.Slice = "system-hydra.slice";
    };

    systemd.services.hydra-server = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "hydra-init.service" ];
      after = [ "hydra-init.service" ];
      path = [
        # these are used to serve logs if they are compressed with zstd or bzip2
        pkgs.zstd
        pkgs.bzip2
      ];
      environment = serverEnv // {
        HYDRA_DATABASE_URL = dbUrlWithAppName "hydra-server";
      };
      restartTriggers = [ hydraConf ];
      serviceConfig = {
        ExecStart =
          "@${hydra-package}/bin/hydra-server hydra-server -f -h '${cfg.listenHost}' "
          + "-p ${toString cfg.port} --min_spare_servers ${toString cfg.minSpareServers} --max_spare_servers ${toString cfg.maxSpareServers} "
          + "--max_servers ${toString cfg.maxServers} --max_requests 100 ${lib.optionalString cfg.debugServer "-d"}";
        User = "hydra-www";
        PermissionsStartOnly = true;
        Restart = "always";
        Slice = "system-hydra.slice";
      };
    };

    systemd.services.hydra-queue-runner = {
      description = "Hydra queue runner";
      wantedBy = [ "multi-user.target" ];
      requires = [
        "hydra-init.service"
        "nix-daemon.socket"
        "hydra-queue-runner-rest.socket"
        "hydra-queue-runner-grpc.socket"
      ];
      after = [
        "hydra-init.service"
        "network.target"
      ];
      reloadTriggers = [ config.environment.etc."hydra/queue-runner.toml".source ];

      environment = {
        NIX_REMOTE = "daemon";
        RUST_BACKTRACE = "1";
        # nix-store wants $HOME for its cache dir.
        HOME = "/run/hydra-queue-runner";
      }
      // lib.optionalAttrs (queueRunnerCfg.awsCredentialsFile != null) {
        AWS_SHARED_CREDENTIALS_FILE = queueRunnerCfg.awsCredentialsFile;
      };

      serviceConfig = {
        Type = "notify";
        Restart = "always";
        RestartSec = "5s";
        Slice = "system-hydra.slice";

        # One gRPC stream per builder plus DB pool. 1024 is easily exhausted.
        LimitNOFILE = 65536;

        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe queueRunnerCfg.package)
            "--rest-bind"
            "-"
            "--grpc-bind"
            "-"
            "--config-path"
            "/etc/hydra/queue-runner.toml"
          ]
          ++ lib.optionals (queueRunnerCfg.mtls != null) [
            "--server-cert-path"
            queueRunnerCfg.mtls.serverCertPath
            "--server-key-path"
            queueRunnerCfg.mtls.serverKeyPath
            "--client-ca-cert-path"
            queueRunnerCfg.mtls.clientCaCertPath
          ]
        );
        ExecReload = "${pkgs.util-linux}/bin/kill -HUP $MAINPID";

        User = "hydra-queue-runner";
        Group = "hydra";

        RuntimeDirectory = "hydra-queue-runner";
        WorkingDirectory = "${baseDir}/queue-runner";

        # Created by hydra-init. StateDirectory= would chown ${baseDir}.
        ReadWritePaths = [
          "/nix/var/nix/gcroots/"
          "/nix/var/nix/daemon-socket/socket"
          "${baseDir}/build-logs/"
          "${baseDir}/queue-runner/"
        ]
        ++ lib.optionals (lib.hasInfix "%2Frun%2Fpostgresql" queueRunnerCfg.settings.dbUrl) [
          "/run/postgresql/.s.PGSQL.${toString config.services.postgresql.settings.port}"
        ];
        ReadOnlyPaths = [ "/nix/" ];

        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0022";
      };
    };

    systemd.sockets.hydra-queue-runner-rest = {
      description = "Hydra queue runner REST socket";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = "${queueRunnerCfg.rest.address}:${toString queueRunnerCfg.rest.port}";
        FileDescriptorName = "rest";
        Service = "hydra-queue-runner.service";
      };
    };

    systemd.sockets.hydra-queue-runner-grpc = {
      description = "Hydra queue runner gRPC socket";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = "${queueRunnerCfg.grpc.address}:${toString queueRunnerCfg.grpc.port}";
        FileDescriptorName = "grpc";
        Service = "hydra-queue-runner.service";
      };
    };

    environment.etc."hydra/queue-runner.toml".source = toml.generate "queue-runner.toml" (
      lib.filterAttrsRecursive (_: v: v != null) queueRunnerCfg.settings
    );

    systemd.services.hydra-ws = lib.mkIf cfg.ws.enable {
      description = "Hydra WebSocket server";
      wantedBy = [ "multi-user.target" ];
      requires = [ "hydra-ws.socket" ];
      after = [
        "hydra-init.service"
        "network.target"
      ];
      reloadTriggers = [ config.environment.etc."hydra/ws.toml".source ];

      serviceConfig = {
        Type = "notify";
        Restart = "always";
        RestartSec = "5s";
        Slice = "system-hydra.slice";

        ExecStart = lib.escapeShellArgs [
          (lib.getExe cfg.ws.package)
          "--bind"
          "-"
          "--config-path"
          "/etc/hydra/ws.toml"
        ];

        User = "hydra-ws";
        Group = "hydra";

        RuntimeDirectory = "hydra-ws";

        ReadOnlyPaths = [ "${baseDir}/build-logs/" ];
        ReadWritePaths = lib.optionals (lib.hasInfix "%2Frun%2Fpostgresql" cfg.ws.settings.dbUrl) [
          "/run/postgresql/.s.PGSQL.${toString config.services.postgresql.settings.port}"
        ];

        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0022";
      };
    };

    systemd.sockets.hydra-ws = lib.mkIf cfg.ws.enable {
      description = "Hydra WebSocket socket";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenStream = "${cfg.ws.bind.address}:${toString cfg.ws.bind.port}";
        FileDescriptorName = "ws";
        Service = "hydra-ws.service";
      };
    };

    environment.etc."hydra/ws.toml" = lib.mkIf cfg.ws.enable {
      source = toml.generate "ws.toml" (lib.filterAttrsRecursive (_: v: v != null) cfg.ws.settings);
    };

    systemd.services.hydra-evaluator = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "hydra-init.service" ];
      wants = [ "network-online.target" ];
      after = [
        "hydra-init.service"
        "network.target"
        "network-online.target"
      ];
      path = [
        pkgs.hostname-debian
        pkgs.jq
        hydra-package # hydra-eval-jobset
      ];
      restartTriggers = [
        hydraConf
        config.environment.etc."hydra/evaluator.toml".source
      ];
      environment = env // {
        HYDRA_DATABASE_URL = dbUrlWithAppName "hydra-evaluator";
      };
      serviceConfig = {
        ExecStart = lib.escapeShellArgs [
          "@${lib.getExe cfg.evaluatorPackage}"
          "hydra-evaluator"
          "--config-path"
          "/etc/hydra/evaluator.toml"
        ];
        ExecStopPost = lib.escapeShellArgs [
          (lib.getExe cfg.evaluatorPackage)
          "--config-path"
          "/etc/hydra/evaluator.toml"
          "--unlock"
        ];
        User = "hydra";
        Restart = "always";
        WorkingDirectory = baseDir;
        Slice = "system-hydra.slice";
      };
    };

    environment.etc."hydra/evaluator.toml".source =
      toml.generate "evaluator.toml" cfg.evaluatorSettings;

    systemd.services.hydra-update-gc-roots = {
      requires = [ "hydra-init.service" ];
      after = [ "hydra-init.service" ];
      environment = env // {
        HYDRA_DATABASE_URL = dbUrlWithAppName "hydra-update-gc-roots";
      };
      serviceConfig = {
        ExecStart = "@${hydra-package}/bin/hydra-update-gc-roots hydra-update-gc-roots";
        User = "hydra";
        Slice = "system-hydra.slice";
      };
      startAt = "2,14:15";
    };

    systemd.services.hydra-send-stats = {
      wantedBy = [ "multi-user.target" ];
      after = [ "hydra-init.service" ];
      environment = env // {
        HYDRA_DATABASE_URL = dbUrlWithAppName "hydra-send-stats";
      };
      serviceConfig = {
        ExecStart = "@${hydra-package}/bin/hydra-send-stats hydra-send-stats";
        User = "hydra";
        Slice = "system-hydra.slice";
      };
    };

    systemd.services.hydra-notify = {
      wantedBy = [ "multi-user.target" ];
      requires = [ "hydra-init.service" ];
      after = [ "hydra-init.service" ];
      restartTriggers = [ hydraConf ];
      path = [ pkgs.zstd ];
      environment = env // {
        PGPASSFILE = "${baseDir}/pgpass-queue-runner";
        HYDRA_DATABASE_URL = dbUrlWithAppName "hydra-notify";
      };
      serviceConfig = {
        ExecStart = "@${hydra-package}/bin/hydra-notify hydra-notify";
        # FIXME: run this under a less privileged user?
        User = "hydra-queue-runner";
        Restart = "always";
        RestartSec = 5;
        Slice = "system-hydra.slice";
      };
    };

    # If there is less than a certain amount of free disk space, stop
    # the queue/evaluator to prevent builds from failing or aborting.
    systemd.services.hydra-check-space = {
      script = ''
        if [ $(($(stat -f -c '%a' /nix/store) * $(stat -f -c '%S' /nix/store))) -lt $((${toString cfg.minimumDiskFree} * 1024**3)) ]; then
            echo "stopping Hydra queue runner due to lack of free space..."
            systemctl stop hydra-queue-runner
        fi
        if [ $(($(stat -f -c '%a' /nix/store) * $(stat -f -c '%S' /nix/store))) -lt $((${toString cfg.minimumDiskFreeEvaluator} * 1024**3)) ]; then
            echo "stopping Hydra evaluator due to lack of free space..."
            systemctl stop hydra-evaluator
        fi
      '';
      startAt = "*:0/5";
      serviceConfig.Slice = "system-hydra.slice";
    };

    # Periodically compress build logs. The queue runner compresses
    # logs automatically after a step finishes, but this doesn't work
    # if the queue runner is stopped prematurely.
    systemd.services.hydra-compress-logs = {
      path = [
        pkgs.bzip2
        pkgs.zstd
      ];
      script = ''
        set -eou pipefail
        compression=$(sed -nr 's/compress_build_logs_compression = ()/\1/p' ${baseDir}/hydra.conf)
        if [[ $compression == "" || $compression == bzip2 ]]; then
          compressionCmd=(bzip2)
        elif [[ $compression == zstd ]]; then
          compressionCmd=(zstd --rm)
        fi
        find ${baseDir}/build-logs -ignore_readdir_race -type f -name "*.drv" -mtime +3 -size +0c -print0 | xargs -0 -r "''${compressionCmd[@]}" --force --quiet
      '';
      startAt = "Sun 01:45";
      serviceConfig.Slice = "system-hydra.slice";
    };

    services.postgresql.enable = lib.mkIf haveLocalDB true;

    services.postgresql.identMap = lib.optionalString haveLocalDB (
      ''
        hydra hydra hydra
        hydra hydra-queue-runner hydra
        hydra hydra-www hydra
        hydra root hydra
      ''
      + lib.optionalString cfg.ws.enable ''
        hydra hydra-ws hydra
      ''
    );

    services.postgresql.authentication = lib.optionalString haveLocalDB ''
      local all hydra peer map=hydra
    '';

  };

}
