{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.bookorbit;

  inherit (lib)
    getExe
    getExe'
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  postgresqlPackage = config.services.postgresql.package;

  environment = lib.mapAttrsToList (k: v: "${k}=${if builtins.isInt v then toString v else v}") (
    lib.filterAttrs (_: v: v != null) cfg.environment
  );
in
{
  options.services.bookorbit = {
    enable = mkEnableOption "BookOrbit";

    package = mkPackageOption pkgs "bookorbit" { };

    user = mkOption {
      type = types.str;
      default = "bookorbit";
      description = "User account under which BookOrbit runs.";
    };

    group = mkOption {
      type = types.str;
      default = "bookorbit";
      description = "Group under which BookOrbit runs.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open the appropriate ports in the firewall for BookOrbit.";
    };

    createDatabaseLocally = mkOption {
      type = types.bool;
      default = true;
      description = "Create the database locally.";
    };

    environment = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf types.str;
        options = {
          APP_DATA_PATH = mkOption {
            type = types.str;
            default = "/var/lib/bookorbit";
            description = "Data storage directory.";
          };
          PORT = mkOption {
            type = types.port;
            default = 3000;
            description = "TCP port for the BookOrbit server.";
          };
          DATABASE_URL = mkOption {
            type = types.str;
            default =
              if cfg.createDatabaseLocally then
                "postgresql:///bookorbit?host=/run/postgresql&user=bookorbit"
              else
                "";
            defaultText = lib.literalExpression "if cfg.createDatabaseLocally then \"postgresql:///bookorbit?host=/run/postgresql&user=bookorbit\" else \"\"";
            description = "The URL of the postgresql database.";
          };
        };
      };
      default = { };
      example = {
        APP_URL = "https://bookorbit.example.com";
        JWT_SECRET = "change-me";
        SETUP_BOOTSTRAP_TOKEN = "change-me";
      };
      description = ''
        Environment variables to pass to the BookOrbit service.
        See <https://bookorbit.app/installation.html#configuration> for available options.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      example = "/run/secrets/bookorbit";
      default = null;
      description = ''
        Path of a file with extra environment variables to be loaded from disk.
        This file is not added to the nix store, so it can be used to pass secrets to BookOrbit.
        See <https://bookorbit.app/installation.html#configuration> for available options.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.groups = mkIf (cfg.group == "bookorbit") {
      bookorbit = { };
    };

    users.users = mkIf (cfg.user == "bookorbit") {
      bookorbit = {
        group = cfg.group;
        description = "bookorbit Daemon user";
        isSystemUser = true;
      };
    };

    systemd.services = {
      bookorbit = {
        description = "BookOrbit";
        after = [
          "network-online.target"
          "postgresql.target"
          "bookorbit-migrate.service"
        ];
        requires = [ "bookorbit-migrate.service" ];
        wants = [
          "network-online.target"
          "postgresql.target"
        ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          ExecStart = getExe cfg.package;
          StateDirectory = "bookorbit";
          Environment = environment;
          EnvironmentFile = cfg.environmentFile;

          ProtectSystem = "full";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          PrivateMounts = true;
          ProtectControlGroups = true;
          ProtectKernelTunables = true;
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          UMask = "0077";

          CapabilityBoundingSet = [ "" ];
          NoNewPrivileges = true;

          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectClock = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
            "@chown"
            "@chmod"
          ];

          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
            "AF_NETLINK"
          ];

          PrivateUsers = true;

          LockPersonality = true;
          ProtectHostname = true;
          RestrictRealtime = true;
          RestrictNamespaces = true;
          ProtectProc = "invisible";
          ProcSubset = "pid";
          DeviceAllow = [ "" ];
        };
      };

      postgresql-setup.serviceConfig.ExecStartPost =
        let
          extensions = [
            "uuid-ossp"
            "pg_trgm"
            "vector"
          ];
          sqlFile = pkgs.writeText "bookorbit-pgext-setup.sql" ''
            ${lib.concatMapStringsSep "\n" (ext: "CREATE EXTENSION IF NOT EXISTS \"${ext}\";") extensions}
          '';
        in
        mkIf cfg.createDatabaseLocally [
          ''
            ${lib.getExe' postgresqlPackage "psql"} -d "bookorbit" -f "${sqlFile}"
          ''
        ];

      bookorbit-migrate = {
        description = "BookOrbit database migration";
        after = [ "postgresql.target" ];
        wants = [ "postgresql.target" ];

        serviceConfig = {
          Type = "oneshot";
          User = cfg.user;
          Group = cfg.group;
          Environment = environment;

          ExecStart = getExe' cfg.package "bookorbit-migrate";
        };
      };
    };

    services.postgresql = mkIf cfg.createDatabaseLocally {
      enable = true;
      extensions = ps: with ps; [ pgvector ];
      ensureDatabases = [ "bookorbit" ];
      ensureUsers = [
        {
          name = "bookorbit";
          ensureDBOwnership = true;
        }
      ];
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.environment.PORT ];
  };

  meta = {
    maintainers = with lib.maintainers; [ iv-nn ];
  };
}
