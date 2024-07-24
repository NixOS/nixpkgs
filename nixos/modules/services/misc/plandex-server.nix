{ config, pkgs, lib, ... }:
let
  inherit (lib) mkOption types mdDoc mkIf;
  cfg = config.services.plandex-server;
in
{
  options = {
    services.plandex-server = {
      enable = lib.mkEnableOption (mdDoc "Plandex Server");

      package = lib.mkPackageOption pkgs "plandex-server" { };

      port = mkOption {
        type = types.port;
        default = 8088;
        description = mdDoc "The port the plandex server should listen on.";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = mdDoc "Open ports in the firewall for the plandex server.";
      };

      stateDir = mkOption {
        default = "/var/lib/plandex";
        type = types.str;
        description = lib.mdDoc "Plandex data directory.";
      };

      database = {
        createLocally = mkOption {
          type = types.bool;
          default = true;
          description = (mdDoc "Create the database and database user locally.");
        };
        uri = mkOption {
          type = types.nullOr types.str;
          default = "postgresql:///plandex?host=/run/postgresql";
          example = "postgresql://plandex@localhost:5432/plandex";
          description = mdDoc "URI to the database.";
        };
      };
      smtp = mkOption {
        default = null;
        description = mdDoc "SMTP settings for plandex-server.";
        type = types.nullOr (types.submodule {
          options = {
            host = mkOption {
              type = types.str;
              description = mdDoc "SMTP server to use.";
            };
            port = mkOption {
              type = types.port;
              description = mdDoc "Port for the SMTP server.";
            };
            user = mkOption {
              type = types.str;
              description = mdDoc "User for the SMTP server.";
            };
            passwordFile = mkOption {
              type = types.str;
              description = mdDoc "File containing password for the SMTP server.";
            };
            from = mkOption {
              type = types.nullOr types.str;
              description = mdDoc "From address to use for the SMTP server.";
              default = null;
            };
          };
        });
      };

      goEnv = mkOption {
        type = types.enum [ "production" "development" ];
        default = "production";
        description = mdDoc "Specifies the type of environment to run. One of 'development' or 'production'.";
      };
    };
  };
  config = mkIf cfg.enable {
    warnings =
      if cfg.goEnv == "production" && isNull cfg.smtp
      then [
        "SMTP settings should be specified for Plandex registrations and invites to work."
      ]
      else [ ];
    assertions = [
      {
        assertion = cfg.database.createLocally -> config.services.postgresql.enable;
        message = "Postgresql must be enabled to create the local database";
      }
    ];
    services.postgresql = mkIf cfg.database.createLocally {
      enable = true;
      ensureUsers = [{
        name = "plandex";
        ensureDBOwnership = true;
      }];
      ensureDatabases = [ "plandex" ];
    };

    systemd.services.plandex = {
      description = "plandex server";
      requires = lib.optionals cfg.database.createLocally [ "postgresql.service" ];
      after = [ "network.target" ] ++ lib.optionals cfg.database.createLocally [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];

      path = [
        pkgs.git
      ];

      serviceConfig = {
        ExecStartPre = mkIf (! isNull cfg.smtp)
          ("+" + pkgs.writeShellScript "preStart" ''
            echo "export SMTP_PASSWORD=$(cat ${cfg.smtp.passwordFile})" > "${cfg.stateDir}/.smtp_pass"
            chown plandex:plandex "${cfg.stateDir}/.smtp_pass"
          '');
        ExecStart = (pkgs.writeShellScript "start" ''
          ${lib.optionalString (! isNull cfg.smtp) ''source "${cfg.stateDir}/.smtp_pass"''}
          ${lib.getExe cfg.package}
        '');
        RuntimeDirectory = "plandex";
        RuntimeDirectoryMode = "0700";
        WorkingDirectory = cfg.stateDir;
        StateDirectory = "plandex";
        DynamicUser = true;
        User = "plandex";
        Group = "plandex";

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
        DATABASE_URL = cfg.database.uri;
        PORT = toString cfg.port;
        HOME = cfg.stateDir;
        GOENV = cfg.goEnv;
      } // (if (! isNull cfg.smtp) then {
        SMTP_HOST = cfg.smtp.host;
        SMTP_PORT = toString cfg.smtp.port;
        SMTP_USER = cfg.smtp.user;
        SMTP_FROM = cfg.smtp.from;
      } else { });
    };

    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];
  };
}
