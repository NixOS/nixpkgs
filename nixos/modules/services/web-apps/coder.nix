{
  config,
  lib,
  options,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.coder;
  name = "coder";
in
{
  options = {
    services.coder = {
      enable = mkEnableOption "Coder service";

      user = mkOption {
        type = types.str;
        default = "coder";
        description = ''
          User under which the coder service runs.

          ::: {.note}
          If left as the default value this user will automatically be created
          on system activation, otherwise it needs to be configured manually.
          :::
        '';
      };

      group = mkOption {
        type = types.str;
        default = "coder";
        description = ''
          Group under which the coder service runs.

          ::: {.note}
          If left as the default value this group will automatically be created
          on system activation, otherwise it needs to be configured manually.
          :::
        '';
      };

      package = mkPackageOption pkgs "coder" { };

      homeDir = mkOption {
        type = types.str;
        description = ''
          Home directory for coder user.
        '';
        default = "/var/lib/coder";
      };

      listenAddress = mkOption {
        type = types.str;
        description = ''
          Listen address.
        '';
        default = "127.0.0.1:3000";
      };

      accessUrl = mkOption {
        type = types.nullOr types.str;
        description = ''
          Access URL should be a external IP address or domain with DNS records pointing to Coder.
        '';
        default = null;
        example = "https://coder.example.com";
      };

      wildcardAccessUrl = mkOption {
        type = types.nullOr types.str;
        description = ''
          If you are providing TLS certificates directly to the Coder server, you must use a single certificate for the root and wildcard domains.
        '';
        default = null;
        example = "*.coder.example.com";
      };

      environment = {
        extra = mkOption {
          type = types.attrs;
          description = "Extra environment variables to pass run Coder's server with. See Coder documentation.";
          default = { };
          example = {
            CODER_OAUTH2_GITHUB_ALLOW_SIGNUPS = true;
            CODER_OAUTH2_GITHUB_ALLOWED_ORGS = "your-org";
          };
        };
        file = mkOption {
          type = types.nullOr types.path;
          description = "Systemd environment file to add to Coder.";
          default = null;
        };
      };

      database = {
        createLocally = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Create the database and database user locally.
          '';
        };

        host = mkOption {
          type = types.str;
          default = "/run/postgresql";
          description = ''
            Hostname hosting the database.
          '';
        };

        database = mkOption {
          type = types.str;
          default = "coder";
          description = ''
            Name of database.
          '';
        };

        username = mkOption {
          type = types.str;
          default = "coder";
          description = ''
            Username for accessing the database.
          '';
        };

        password = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = ''
            Password for accessing the database.
          '';
        };

        sslmode = mkOption {
          type = types.nullOr types.str;
          default = "disable";
          description = ''
            Password for accessing the database.
          '';
        };
      };

      tlsCert = mkOption {
        type = types.nullOr types.path;
        description = ''
          The path to the TLS certificate.
        '';
        default = null;
      };

      tlsKey = mkOption {
        type = types.nullOr types.path;
        description = ''
          The path to the TLS key.
        '';
        default = null;
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.database.createLocally
          -> cfg.database.username == name && cfg.database.database == cfg.database.username;
        message = "services.coder.database.username must be set to ${name} if services.coder.database.createLocally is set true";
      }
    ];

    systemd.services.coder = {
      description = "Coder - Self-hosted developer workspaces on your infra";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = cfg.environment.extra // {
        CODER_ACCESS_URL = cfg.accessUrl;
        CODER_WILDCARD_ACCESS_URL = cfg.wildcardAccessUrl;
        CODER_PG_CONNECTION_URL = "user=${cfg.database.username} ${
          optionalString (cfg.database.password != null) "password=${cfg.database.password}"
        } database=${cfg.database.database} host=${cfg.database.host} ${
          optionalString (cfg.database.sslmode != null) "sslmode=${cfg.database.sslmode}"
        }";
        CODER_ADDRESS = cfg.listenAddress;
        CODER_TLS_ENABLE = optionalString (cfg.tlsCert != null) "1";
        CODER_TLS_CERT_FILE = cfg.tlsCert;
        CODER_TLS_KEY_FILE = cfg.tlsKey;
      };

      serviceConfig = {
        ProtectSystem = "full";
        PrivateTmp = "yes";
        PrivateDevices = "yes";
        SecureBits = "keep-caps";
        AmbientCapabilities = "CAP_IPC_LOCK CAP_NET_BIND_SERVICE";
        CacheDirectory = "coder";
        CapabilityBoundingSet = "CAP_SYSLOG CAP_IPC_LOCK CAP_NET_BIND_SERVICE";
        KillSignal = "SIGINT";
        KillMode = "mixed";
        NoNewPrivileges = "yes";
        Restart = "on-failure";
        ExecStart = "${cfg.package}/bin/coder server";
        User = cfg.user;
        Group = cfg.group;
        EnvironmentFile = lib.mkIf (cfg.environment.file != null) cfg.environment.file;
      };
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [
        cfg.database.database
      ];
      ensureUsers = [
        {
          name = cfg.user;
          ensureDBOwnership = true;
        }
      ];
    };

    users.groups = optionalAttrs (cfg.group == name) {
      "${cfg.group}" = { };
    };
    users.users = optionalAttrs (cfg.user == name) {
      ${name} = {
        description = "Coder service user";
        group = cfg.group;
        home = cfg.homeDir;
        createHome = true;
        isSystemUser = true;
      };
    };
  };
  meta.maintainers = pkgs.coder.meta.maintainers;
}
