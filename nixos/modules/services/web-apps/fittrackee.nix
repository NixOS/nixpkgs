{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.fittrackee;

  commonService = {
    wantedBy = [ "multi-user.target" ];
    after = [
      "network.target"
      "postgresql.service"
      "redis.service"
    ];
    inherit (cfg) environment;
    serviceConfig = {
      User = "fittrackee";
      Group = "fittrackee";
      StateDirectory = "fittrackee";
      EnvironmentFile = [ cfg.environmentFile ];
      #WorkingDirectory = "${pkgs.fittrackee}/lib"

      # hardening
      AmbientCapabilities = [ "" ];
      CapabilityBoundingSet = [ "" ];
      DevicePolicy = "closed";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      PrivateUsers = true;
      ProcSubset = "pid";
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "~@resources"
        "~@privileged"
      ];
      UMask = "0077";
    };
  };
in
{
  options.services.fittrackee = {
    enable = lib.mkEnableOption "FitTrackee";

    environment = lib.mkOption {
      default = { };
      description = ''
        Environment variables used to configure the FitTrackee web application
        and the task processing library. See
        <https://samr1.github.io/FitTrackee/en/installation.html#environment-variables>
        for supported values.
      '';
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf lib.types.str;

        options = {
          HOST = lib.mkOption {
            default = "127.0.0.1";
            description = "FitTrackee host.";
            type = lib.types.str;
          };

          PORT = lib.mkOption {
            apply = toString;
            default = 5000;
            description = "FitTrackee port.";
            type = lib.types.port;
          };

          UPLOAD_FOLDER = lib.mkOption {
            default = "/var/lib/fittrackee";
            description = "Absolute path to the directory where the {file}`uploads` folder will be created.";
            type = lib.types.path;
          };

          DATABASE_URL = lib.mkOption {
            default = "postgresql:///fittrackee?host=/run/postgresql";
            description = "Database URL with username and password.";
            example = "postgresql://fittrackee:fittrackee@localhost:5432/fittrackee";
            type = lib.types.str;
          };

          WORKERS_PROCESSES = lib.mkOption {
            apply = toString;
            default = 1;
            description = "Number of processes used by Dramatiq.";
            type = lib.types.ints.positive;
          };
        };
      };
    };

    environmentFile = lib.mkOption {
      default = null;
      description = ''
        Environment file, as defined in {manpage}`systemd.exec(5)`, setting
        environment variables used to configure the FitTrackee web application
        and the task processing library. In contrast to {option}`environment`
        you can specify secrets here. In particular {env}`APP_SECRET_KEY`
        should be specified here.
      '';
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.fittrackee ];

    services.postgresql = {
      ensureDatabases = [ "fittrackee" ];
      ensureUsers = [
        {
          name = "fittrackee";
          ensureDBOwnership = true;
        }
      ];
    };

    # see https://samr1.github.io/FitTrackee/en/installation.html#deployment
    systemd.services.fittrackee = lib.recursiveUpdate commonService {
      description = "FitTrackee service";
      serviceConfig = {
        ExecStartPre = "${lib.getExe' pkgs.fittrackee "ftcli"} db upgrade";
        ExecStart = lib.getExe' pkgs.fittrackee "fittrackee";
      };
    };


    /*systemd.services.fittrackee-workers = lib.recursiveUpdate commonService {
      description = "FitTrackee task queue service";
      after = [ "fittrackee.service" ];
      serviceConfig = {
        ExecStart = "flask worker --processes $WORKERS_PROCESSES";
      };
    };*/

    users.users.fittrackee = {
      group = "fittrackee";
      isSystemUser = true;
    };
    users.groups.fittrackee.members = [ "fittrackee" ];
  };

  meta = {
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
