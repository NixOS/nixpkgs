{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.hydra-builder;

  user = "hydra-builder";

  format = pkgs.formats.toml { };
in
{
  options.services.hydra-builder = {
    enable = lib.mkEnableOption "the Hydra build agent, which connects to the queue runner over gRPC and executes builds";

    package = lib.mkPackageOption pkgs "hydra-builder" { };

    queueRunnerAddr = lib.mkOption {
      type = lib.types.singleLineStr;
      example = "http://hydra.example.org:50051";
      description = ''
        Address of the queue runner's gRPC endpoint, see
        {option}`services.hydra.queueRunner.grpc`.
      '';
    };

    settings = lib.mkOption {
      description = ''
        Builder settings, written to {file}`/etc/hydra/builder.toml`.
      '';
      default = { };
      type = lib.types.submodule {
        options = {
          pingInterval = lib.mkOption {
            type = lib.types.ints.positive;
            default = 10;
            description = "Interval in seconds at which pings are sent to the queue runner.";
          };

          speedFactor = lib.mkOption {
            type = lib.types.oneOf [
              lib.types.ints.positive
              lib.types.float
            ];
            default = 1;
            description = "Speed factor of this machine, relative to the other builders.";
          };

          maxJobs = lib.mkOption {
            type = lib.types.ints.positive;
            default = 4;
            description = ''
              Maximum number of concurrent jobs. Only honoured when the queue
              runner's {option}`services.hydra.queueRunner.settings.machineFreeFn`
              takes job limits into account.
            '';
          };

          buildCores = lib.mkOption {
            type = lib.types.ints.unsigned;
            default = config.nix.settings.cores;
            defaultText = lib.literalExpression "config.nix.settings.cores";
            description = ''
              Cores made available to each build (`NIX_BUILD_CORES`). 0 means
              all available cores.
            '';
          };

          buildDirAvailThreshold = lib.mkOption {
            type = lib.types.float;
            default = 10.0;
            description = ''
              Percentage of free space on the Nix build directory below which
              jobs stop being scheduled on this machine.
            '';
          };

          storeAvailThreshold = lib.mkOption {
            type = lib.types.float;
            default = 10.0;
            description = ''
              Percentage of free space on {file}`/nix/store` below which jobs
              stop being scheduled on this machine.
            '';
          };

          load1Threshold = lib.mkOption {
            type = lib.types.float;
            default = 8.0;
            description = ''
              Load1 above which jobs stop being scheduled on this machine. Only
              used when PSI is unavailable.
            '';
          };

          cpuPsiThreshold = lib.mkOption {
            type = lib.types.float;
            default = 75.0;
            description = "CPU PSI over the last 10s above which jobs stop being scheduled on this machine.";
          };

          memPsiThreshold = lib.mkOption {
            type = lib.types.float;
            default = 80.0;
            description = "Memory PSI over the last 10s above which jobs stop being scheduled on this machine.";
          };

          ioPsiThreshold = lib.mkOption {
            type = lib.types.nullOr lib.types.float;
            default = null;
            description = ''
              IO PSI over the last 10s above which jobs stop being scheduled on
              this machine. `null` disables this check.
            '';
          };

          systems = lib.mkOption {
            type = lib.types.nullOr (lib.types.listOf lib.types.singleLineStr);
            default = null;
            example = [ "x86_64-linux" ];
            description = ''
              Systems this builder can build for. `null` reads `system` and
              `extra-platforms` from Nix; an empty list advertises none.
            '';
          };

          supportedFeatures = lib.mkOption {
            type = lib.types.nullOr (lib.types.listOf lib.types.singleLineStr);
            default = null;
            example = [ "big-parallel" ];
            description = ''
              Features this builder supports. `null` reads `system-features`
              from Nix; an empty list advertises none.
            '';
          };

          mandatoryFeatures = lib.mkOption {
            type = lib.types.listOf lib.types.singleLineStr;
            default = [ ];
            example = [ "FOD" ];
            description = "Features a step must request to be scheduled on this builder.";
          };

          useSubstitutes = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether the builder substitutes paths instead of fetching them from the queue runner.";
          };
        };
      };
    };

    authorizationFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a file holding the authorization token, as an alternative to
        {option}`mtls`. The token has to be listed in the queue runner's
        {option}`services.hydra.queueRunner.settings.tokenPaths`.
      '';
    };

    mtls = lib.mkOption {
      default = null;
      description = "mTLS material used to authenticate against the queue runner.";
      type = lib.types.nullOr (
        lib.types.submodule {
          options = {
            serverRootCaCertPath = lib.mkOption {
              type = lib.types.path;
              description = "Server root CA certificate path.";
            };

            clientCertPath = lib.mkOption {
              type = lib.types.path;
              description = "Client certificate path.";
            };

            clientKeyPath = lib.mkOption {
              type = lib.types.path;
              description = "Client key path.";
            };

            domainName = lib.mkOption {
              type = lib.types.singleLineStr;
              description = "Domain name the server certificate is validated against.";
            };
          };
        }
      );
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.hydra-builder = {
      description = "Hydra build agent";
      requires = [ "nix-daemon.socket" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ config.environment.etc."hydra/builder.toml".source ];

      environment = {
        NIX_REMOTE = "daemon";
        RUST_BACKTRACE = "1";
        # nix-store wants $HOME for its cache dir.
        HOME = "/run/hydra-builder";
      };

      path = [ config.nix.package ];

      serviceConfig = {
        Type = "notify";
        Restart = "always";
        RestartSec = "5s";

        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe cfg.package)
            "--gateway-endpoint"
            cfg.queueRunnerAddr
            "--config-path"
            "/etc/hydra/builder.toml"
          ]
          ++ lib.optionals (cfg.authorizationFile != null) [
            "--authorization-file"
            cfg.authorizationFile
          ]
          ++ lib.optionals (cfg.mtls != null) [
            "--server-root-ca-cert-path"
            cfg.mtls.serverRootCaCertPath
            "--client-cert-path"
            cfg.mtls.clientCertPath
            "--client-key-path"
            cfg.mtls.clientKeyPath
            "--domain-name"
            cfg.mtls.domainName
          ]
        );

        User = user;
        Group = "hydra";

        RuntimeDirectory = "hydra-builder";

        ReadWritePaths = [
          "/nix/var/nix/gcroots/"
          "/nix/var/nix/daemon-socket/socket"
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
        UMask = "0077";
      };
    };

    environment.etc."hydra/builder.toml".source = format.generate "builder.toml" (
      lib.filterAttrsRecursive (_: v: v != null) cfg.settings
    );

    nix.settings.trusted-users = [ user ];

    users = {
      groups.hydra = { };
      users.${user} = {
        description = "Hydra build agent";
        group = "hydra";
        isSystemUser = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    conni2461
    das_j
    helsinki-Jo
    mindavi
  ];
}
