{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.codechecker-server;

  cliConfig = {
    "server" = [
      "--workspace=${cfg.serverSettings.stateDir}"
      "--host=${cfg.serverSettings.address}"
      "--port=${toString cfg.serverSettings.port}"
      "--api-handler-processes=${toString cfg.serverSettings.apiWorkers}"
      "--task-worker-processes=${toString cfg.serverSettings.taskWorkers}"
      "--verbose=${cfg.serverSettings.logLevel}"
    ];
  };
  cliConfigFile = pkgs.writeText "cli-config.json" (builtins.toJSON cliConfig);
  serverConfigFile = pkgs.writeText "server_config.json" (builtins.toJSON cfg.settings);
in
{
  options = {
    services.codechecker-server = {
      enable = lib.mkEnableOption "CodeChecker, a static analysis infrastructure supporting multiple compilers";

      package = lib.mkPackageOption pkgs "codechecker" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "codechecker-server";
        description = "User under which CodeChecker is ran.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "codechecker-server";
        description = "Group under which CodeChecker is ran.";
      };

      settings = lib.mkOption {
        type = with lib.types; attrsOf (oneOf [ str int bool attrs path ]);
        description = "";
        default = {
          background_worker_processes = 2;
          worker_processes = 2;
          max_run_count = -1;
          store = {
            analysis_statistics_dir = "/var/lib/codechecker-server/stats";
            limit = {
              failure_zip_size = 52428800;
              compilation_database_size = 104857600;
            };
          };
          keepalive = {
            enable = false;
            idle = 600;
            interval = 30;
            max_probe = 10;
          };
          authentication = {
            enable = false;
            realm_name = "example name";
            realm_error = "Access denied";
            failed_auth_message = "Authentication failed";
            session_lifetime = 300;
            refresh_time = 60;
            logins_until_cleanup = 30;
            max_pers_auth_token_expiration_length = 365;
          };
        };
      };

      serverSettings = {
        address = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = "IP address CodeChecker should bind to.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 8001;
          description = "Port on which CodeChecker is ran.";
        };

        stateDir = lib.mkOption {
          type = lib.types.path;
          default = "/var/lib/codechecker-server";
          description = "";
        };

        logLevel = lib.mkOption {
          type = lib.types.enum [
            "info"
            "debug_analyzer"
            "debug"
          ];
          default = "info";
          description = "";
        };

        apiWorkers = lib.mkOption {
          type = lib.types.int;
          default = 4;
          description = "";
        };

        taskWorkers = lib.mkOption {
          type = lib.types.int;
          default = 4;
          description = "";
        };

        database = {
          type = lib.mkOption {
            type = lib.types.enum [
              "sqlite"
              "postgresql"
            ];
            default = "sqlite";
            example = "postgresql";
            description = "Database engine to use.";
          };

          host = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
            description = "Database host address.";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 5432;
            defaultText = lib.literalExpression "5432";
            description = "database host port.";
          };

          user = lib.mkOption {
            type = lib.types.str;
            default = "codechecker";
            description = "Database user.";
          };

          name = lib.mkOption {
            type = lib.types.str;
            default = "codechecker";
            description = "Database name.";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users = {
      groups.${cfg.group} = { };
      users.${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
      };
    };

    systemd.services.codechecker-server = {
      after = [
        "network.target"
      ];
      preStart = ''
        ln -sf ${serverConfigFile} ${cfg.serverSettings.stateDir}/server_config.json
      '';
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "300";
        ExecStart = "${cfg.package}/bin/CodeChecker server --config ${cliConfigFile}";
        RuntimeDirectory = "codechecker-server";
        RuntimeDirectoryMode = "0750";
        StateDirectory = "codechecker-server";
        StateDirectoryMode = "0750";
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        MountAPIVFS = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ReadWritePaths = [
          cfg.serverSettings.stateDir
        ];
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        UMask = 27;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ felixsinger ];
}
