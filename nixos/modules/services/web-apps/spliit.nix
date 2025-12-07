{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.spliit;
in
{
  meta = {
    maintainers = with lib.maintainers; [ qvalentin ];
  };

  options.services.spliit = with lib; {
    enable = mkEnableOption "Spliit bill-splitting web application";
    package = mkPackageOption pkgs "spliit" { };
    settings = mkOption {
      type = types.submodule {
        freeformType = with types; attrsOf str;
        options = {
          PORT = mkOption {
            type = types.port;
            default = 3000;
            example = 7000;
            description = "The port to use.";
          };
          ADDRESS = mkOption {
            type = types.str;
            default = "127.0.0.1";
            example = "0.0.0.0";
            description = "The address to listen on.";
          };
          POSTGRES_PRISMA_URL = mkOption {
            type = types.nullOr types.str;
            default =
              if cfg.database.createLocally then
                "postgresql://${cfg.database.user}@${cfg.database.name}/${cfg.database.name}?host=/var/run/postgresql/"
              else
                "";
            example = "postgresql://postgres:1234@localhost";
            description = "Connection string for the postgres database";
          };
          POSTGRES_URL_NON_POOLING = mkOption {
            type = types.nullOr types.str;
            default =
              if cfg.database.createLocally then
                "postgresql://${cfg.database.user}@${cfg.database.name}/${cfg.database.name}?host=/var/run/postgresql/"
              else
                "";
            example = "postgresql://postgres:1234@localhost";
            description = "Non-pooling connection string for the postgres database";
          };
        };
      };
      example = literalExpression ''
        {
          PORT = 7000;
          NEXT_PUBLIC_ENABLE_RECEIPT_EXTRACT = true;
        }
      '';
      default = {
        PORT = 3000;
      };
      description = ''
        Environment variables settings for spliit. See <https://github.com/spliit-app/spliit?tab=readme-ov-file#opt-in-features> for the possible options.
        Secrets should use `secretFile` option instead.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "spliit";
      description = "User account under which Spliit runs.";
    };

    group = mkOption {
      type = types.str;
      default = "spliit";
      description = "Group under which Spliit runs.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the firewall for the specified port.";
    };

    configureNginx = mkOption {
      type = types.bool;
      default = false;
      description = "Configure nginx as a reverse proxy for Spliit.";
    };

    host = mkOption {
      type = lib.types.str;
      description = "Domain on which nginx will serve Spliit";
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        A secret file to be sourced for the environment variables settings.
        Place `S3_UPLOAD_KEY`, `OPENAI_API_KEY` and other settings that should not end up in the Nix store here.
      '';
    };

    database = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Create the PostgreSQL database and database user locally.
        '';
      };
      name = mkOption {
        type = types.str;
        default = "spliit";
        description = "Database name.";
      };
      user = mkOption {
        type = types.str;
        default = "spliit";
        description = "Database user.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.spliit = {
      description = "Spliit bill-splitting web application";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ lib.optional cfg.database.createLocally "postgresql.service";
      requires = lib.mkIf cfg.database.createLocally [ "postgresql.service" ];

      environment = lib.mkMerge [
        (lib.mapAttrs (_: toString) cfg.settings)
      ];

      serviceConfig = {
        Type = "simple";
        StateDirectory = "spliit";
        ExecStart = lib.getExe cfg.package;
        Restart = "always";
        LoadCredential = lib.optional (cfg.environmentFile != null) "${cfg.environmentFile}";
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = true;

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = false; # required for Node.js JIT
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          # Required for connecting to database sockets,
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@pkey"
        ];
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        UMask = "0077";
      };
    };

    assertions = [
      {
        assertion =
          cfg.database.createLocally
          -> cfg.settings.POSTGRES_PRISMA_URL == null && cfg.settings.POSTGRES_URL_NON_POOLING == null;
        message = "The options <option>services.spliit.settings.POSTGRES_PRISMA_URL</option> and <option>services.spliit.settings.POSTGRES_URL_NON_POOLING</option>
        should not be set when <option>services.spliit.database.createLocally</option> is set to true";
      }
    ];

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.user;
          ensureDBOwnership = true;
        }
      ];
    };

    services.nginx = lib.mkIf cfg.configureNginx {
      enable = true;
      virtualHosts = {
        ${cfg.host} = {
          locations = {
            "/" = {
              proxyPass = "http://localhost:${toString cfg.port}";
            };
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };

}
