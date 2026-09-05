{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.services.jellystat;

  appEnv = {
    TZ = cfg.settings.timeZone;
    JS_LISTEN_IP = cfg.settings.listenAddress;
    JS_PORT = toString cfg.settings.port;
    JS_BASE_URL = cfg.settings.baseUrl;
    JS_BACKUP_DIR = "${cfg.dataDir}/backups";
    JS_ENV_DIR = "${cfg.dataDir}/env";
    POSTGRES_IP = cfg.settings.database.host;
    POSTGRES_PORT = toString cfg.settings.database.port;
    POSTGRES_DB = cfg.settings.database.name;
    POSTGRES_USER = cfg.settings.database.user;
    POSTGRES_SSL_ENABLED = if cfg.settings.database.sslEnabled then "true" else "false";
    POSTGRES_SSL_REJECT_UNAUTHORIZED =
      if cfg.settings.database.sslRejectUnauthorized then "true" else "false";
  }
  // (lib.optionalAttrs (cfg.settings.jsUser != null) {
    JS_USER = cfg.settings.jsUser;
  })
  // (lib.optionalAttrs (cfg.settings.geolite.accountId != null) {
    JS_GEOLITE_ACCOUNT_ID = cfg.settings.geolite.accountId;
  })
  // cfg.settings.environment;

  secretFiles = lib.filterAttrs (_: v: v != null) {
    JWT_SECRET = cfg.settings.jwtSecretFile;
    POSTGRES_PASSWORD = cfg.settings.database.passwordFile;
    JS_PASSWORD = cfg.settings.jsPasswordFile;
    JS_GEOLITE_LICENSE_KEY = cfg.settings.geolite.licenseKeyFile;
  };

  startScript = pkgs.writeShellScript "jellystat-start" ''
    set -euo pipefail

    ${lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: file: ''
        export ${name}="$(${pkgs.coreutils}/bin/cat ${lib.escapeShellArg file})"
      '') secretFiles
    )}

    exec ${cfg.package}/bin/jellystat
  '';
in
{
  options.services.jellystat = {
    enable = lib.mkEnableOption "Jellystat statistics service for Jellyfin";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.jellystat;
      defaultText = lib.literalExpression "pkgs.jellystat";
      description = "Jellystat package to run.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open firewall for Jellystat's HTTP port.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/jellystat";
      description = "Persistent Jellystat state directory.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "jellystat";
      description = "User account under which Jellystat runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "jellystat";
      description = "Group under which Jellystat runs.";
    };

    settings = {
      port = lib.mkOption {
        type = lib.types.port;
        default = 3000;
        description = "Port Jellystat listens on (JS_PORT).";
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = "Value for JS_LISTEN_IP.";
      };

      baseUrl = lib.mkOption {
        type = lib.types.str;
        default = "/";
        description = "Value for JS_BASE_URL.";
      };

      timeZone = lib.mkOption {
        type = lib.types.str;
        default = "Etc/UTC";
        description = "Value for TZ.";
      };

      jsUser = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Optional JS_USER master override username.";
      };

      jsPasswordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a file containing JS_PASSWORD.";
      };

      jwtSecretFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a file containing JWT_SECRET.";
      };

      geolite = {
        accountId = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Optional JS_GEOLITE_ACCOUNT_ID value.";
        };

        licenseKeyFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to a file containing JS_GEOLITE_LICENSE_KEY.";
        };
      };

      database = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Create local PostgreSQL database/user for Jellystat.";
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "PostgreSQL host for Jellystat.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 5432;
          description = "PostgreSQL port for Jellystat.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "jfstat";
          description = "PostgreSQL database name for Jellystat.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "postgres";
          description = "PostgreSQL user for Jellystat.";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to a file containing POSTGRES_PASSWORD.";
        };

        sslEnabled = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to set POSTGRES_SSL_ENABLED=true.";
        };

        sslRejectUnauthorized = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Value for POSTGRES_SSL_REJECT_UNAUTHORIZED when SSL is enabled.";
        };
      };

      environment = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = ''
          Additional environment variables to pass to Jellystat.

          Variables defined here are merged with the environment variables
          generated by the module. Values defined here take precedence over
          the module-generated values, allowing upstream Jellystat options
          which are not exposed as NixOS options to be configured.
        '';
        example = lib.literalExpression ''
          {
            JS_SOME_UPSTREAM_OPTION = "value";
          }
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings.jwtSecretFile != null;
        message = ''
          services.jellystat requires JWT_SECRET. Please set jwtSecretFile.
        '';
      }
      {
        assertion = cfg.settings.database.passwordFile != null && cfg.settings.database.enable == false;
        message = ''
          services.jellystat requires POSTGRES_PASSWORD when making a database. Please set database.passwordFile.
        '';
      }
    ];

    users.groups.${cfg.group} = { };

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
      description = "Jellystat service user";
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.port ];

    systemd.tmpfiles.settings."10-${cfg.dataDir}" = {
      "${cfg.dataDir}" = {
        d = {
          user = cfg.user;
          group = cfg.group;
          mode = "0750";
        };
      };
      "${cfg.dataDir}/backups" = {
        d = {
          user = cfg.user;
          group = cfg.group;
          mode = "0750";
        };
      };
      "${cfg.dataDir}/env" = {
        d = {
          user = cfg.user;
          group = cfg.group;
          mode = "0750";
        };
      };
    };

    services.postgresql = lib.mkIf cfg.settings.database.enable {
      enable = true;
      ensureDatabases = [ cfg.settings.database.name ];
      ensureUsers = [
        {
          name = cfg.settings.database.user;
          ensureDBOwnership = true;
          ensureClauses.createdb = true;
        }
      ];
    };

    systemd.services.jellystat-postgresql-password = lib.mkIf cfg.settings.database.enable {
      description = "Set Jellystat PostgreSQL password";

      after = [ "postgresql.service" ];
      requires = [ "postgresql.service" ];
      before = [ "jellystat.service" ];

      serviceConfig = {
        Type = "oneshot";
        User = "postgres";
      };

      script = ''
        export JELLYSTAT_DB_PASSWORD="$(${pkgs.coreutils}/bin/cat ${lib.escapeShellArg cfg.settings.database.passwordFile})"

        ${cfg.settings.database.package}/bin/psql \
          --dbname=postgres \
          --set=dbuser="${cfg.settings.database.user}" \
          --set=dbpassword="$JELLYSTAT_DB_PASSWORD" \
          --command='ALTER ROLE :"dbuser" PASSWORD :"dbpassword";'
      '';
    };

    systemd.services.jellystat = {
      description = "Jellystat service";
      wantedBy = [ "multi-user.target" ];
      after = lib.optionals cfg.settings.database.enable [ "jellystat-postgresql-password.service" ] ++ [
        "network-online.target"
      ];
      requires = lib.optionals cfg.settings.database.enable [ "jellystat-postgresql-password.service" ];
      wants = [ "network-online.target" ];

      environment = appEnv;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = "${cfg.package}/share/jellystat/backend";
        ExecStart = startScript;
        Restart = "always";
        RestartSec = "5s";
      };
    };
  };
  meta = with lib; {
    maintainers = with maintainers; [ mistyttm ];
    doc = ./jellystat.md;
  };
}
