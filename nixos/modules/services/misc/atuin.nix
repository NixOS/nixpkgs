{ config, pkgs, lib, ... }:
let
  inherit (lib) mkOption types mkIf;
  cfg = config.services.atuin;
in
{
  options = {
    services.atuin = {
      enable = lib.mkEnableOption "Atuin server for shell history sync";

      package = lib.mkPackageOption pkgs "atuin" { };

      openRegistration = mkOption {
        type = types.bool;
        default = false;
        description = "Allow new user registrations with the atuin server.";
      };

      path = mkOption {
        type = types.str;
        default = "";
        description = "A path to prepend to all the routes of the server.";
      };

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "The host address the atuin server should listen on.";
      };

      maxHistoryLength = mkOption {
        type = types.int;
        default = 8192;
        description = "The max length of each history item the atuin server should store.";
      };

      port = mkOption {
        type = types.port;
        default = 8888;
        description = "The port the atuin server should listen on.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the atuin server.";
      };

      database = {
        createLocally = mkOption {
          type = types.bool;
          default = true;
          description = "Create the database and database user locally.";
        };

        uri = mkOption {
          type = types.nullOr types.str;
          default = "postgresql:///atuin?host=/run/postgresql";
          example = "postgresql://atuin@localhost:5432/atuin";
          description = ''
            URI to the database.
            Can be set to null in which case ATUIN_DB_URI should be set through an EnvironmentFile
          '';
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.createLocally -> config.services.postgresql.enable;
        message = "Postgresql must be enabled to create a local database";
      }
    ];

    services.postgresql = mkIf cfg.database.createLocally {
      enable = true;
      ensureUsers = [{
        name = "atuin";
        ensureDBOwnership = true;
      }];
      ensureDatabases = [ "atuin" ];
    };

    systemd.services.atuin = {
      description = "atuin server";
      requires = lib.optionals cfg.database.createLocally [ "postgresql.service" ];
      after = [ "network.target" ] ++ lib.optionals cfg.database.createLocally [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} server start";
        RuntimeDirectory = "atuin";
        RuntimeDirectoryMode = "0700";
        DynamicUser = true;

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateMounts = true;
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
        ProtectSystem = "full";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          # Required for connecting to database sockets,
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };

      environment = {
        ATUIN_HOST = cfg.host;
        ATUIN_PORT = toString cfg.port;
        ATUIN_MAX_HISTORY_LENGTH = toString cfg.maxHistoryLength;
        ATUIN_OPEN_REGISTRATION = lib.boolToString cfg.openRegistration;
        ATUIN_PATH = cfg.path;
        ATUIN_CONFIG_DIR = "/run/atuin"; # required to start, but not used as configuration is via environment variables
      } // lib.optionalAttrs (cfg.database.uri != null) {
        ATUIN_DB_URI = cfg.database.uri;
      };
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };
}
