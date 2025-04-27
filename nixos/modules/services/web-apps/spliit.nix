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
    enable = mkEnableOption (mdDoc "Spliit bill-splitting web application");
    package = mkPackageOption pkgs "spliit" { };

    port = mkOption {
      type = types.port;
      default = 3000;
      description = mdDoc "Port to listen on.";
    };

    user = mkOption {
      type = types.str;
      default = "spliit";
      description = mdDoc "User account under which Spliit runs.";
    };

    group = mkOption {
      type = types.str;
      default = "spliit";
      description = mdDoc "Group under which Spliit runs.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = mdDoc "Whether to open the firewall for the specified port.";
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

    secretFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        A secret file to be sourced for the environment variables settings.
        Place `S3_UPLOAD_KEY`, `OPENAI_API_KEY` and other settings that should not end up in the Nix store here.
      '';
    };

    settings = mkOption {
      type =
        with types;
        (attrsOf (oneOf [
          bool
          int
          str
        ]));
      default = { };
      description = ''
        Environment variables settings for spliit.
        Secrets should use `secretFile` option instead.
      '';
      example = {
        NEXT_PUBLIC_ENABLE_RECEIPT_EXTRACT = true;
      };
    };

    database = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Create the PostgreSQL database and database user locally.
        '';
      };
      hostname = mkOption {
        type = types.str;
        default = "/run/postgresql";
        description = "Database hostname.";
      };
      port = mkOption {
        type = types.port;
        default = 5432;
        description = "Database port.";
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
      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/spliit-dbpassword";
        description = ''
          A file containing the password corresponding to
          [](#opt-services.spliit.database.user).
        '';
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
        (lib.mkIf cfg.database.createLocally {
          POSTGRES_PRISMA_URL = "postgresql://${cfg.database.user}@${cfg.database.name}/${cfg.database.name}?host=/var/run/postgresql/";
          POSTGRES_URL_NON_POOLING = "postgresql://${cfg.database.user}@${cfg.database.name}/${cfg.database.name}?host=/var/run/postgresql/";
        })
        {
          PORT = toString cfg.port;
        }
        cfg.settings
      ];

      serviceConfig = {
        Type = "simple";

        StateDirectory = "spliit";
        ExecStart =
          if (cfg.database.passwordFile != null) then
            lib.getExe (
              pkgs.writeShellScriptBin "spliit-passwordFile" ''
                set -eu
                DATABASE_PASSWORD="$(cat $CREDENTIALS_DIRECTORY/dbpasswordfile)"

                POSTGRES_PRISMA_URL="postgresql://${cfg.database.user}:$DATABASE_PASSWORD@${cfg.database.hostname}:${toString cfg.database.port}/${cfg.database.name}";

                export POSTGRES_PRISMA_URL="$POSTGRES_PRISMA_URL"
                export POSTGRES_URL_NON_POOLING="$POSTGRES_PRISMA_URL"

                exec ${lib.getExe cfg.package}
              ''
            )
          else
            lib.getExe cfg.package;
        Restart = "always";
        User = cfg.user;
        Group = cfg.group;
        LoadCredential =
          lib.optional (cfg.secretFile != null) "env-secrets:${cfg.secretFile}"
          ++ (lib.optional (cfg.database.passwordFile != null) "dbpasswordfile:${cfg.database.passwordFile}");
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
          # and listening to unix socket at `cfg.settings.path`
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
          cfg.database.createLocally -> cfg.database.user == cfg.user && cfg.database.name == cfg.user;
        message = "<option>services.spliit.database.user</option> and <option>services.spliit.database.name</option> must be
        the same as <option>services.spliit.user</option> if <option>services.spliit.database.createLocally</option> is set to true";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "a password cannot be specified if <option>services.spliit.database.createLocally</option> is set to true";
      }
    ];

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
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
