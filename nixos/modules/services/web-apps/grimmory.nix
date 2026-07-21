{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.grimmory;
in
{
  options.services.grimmory = {
    enable = lib.mkEnableOption "Grimmory, a self-hosted digital library for EPUB, PDF and comics";

    package = lib.mkPackageOption pkgs "grimmory" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "grimmory";
      description = "User account under which Grimmory runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "grimmory";
      description = "Group under which Grimmory runs.";
    };

    host = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address Grimmory's web server listens on (`SERVER_ADDRESS`).";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 6060;
      description = "Port Grimmory's web server listens on (`BOOKLORE_PORT`).";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/grimmory";
      description = ''
        Directory holding Grimmory's internal application state (`APP_PATH_CONFIG`).
      '';
    };

    booksDir = lib.mkOption {
      type = lib.types.path;
      default = "${cfg.dataDir}/books";
      defaultText = lib.literalExpression "\"\${config.services.grimmory.dataDir}/books\"";
      description = ''
        Root directory containing the book library managed by Grimmory.
      '';
    };

    bookdropDir = lib.mkOption {
      type = lib.types.path;
      default = "${cfg.dataDir}/bookdrop";
      defaultText = lib.literalExpression "\"\${config.services.grimmory.dataDir}/bookdrop\"";
      description = ''
        Directory Grimmory watches for dropped book files to auto-import
        (`APP_BOOKDROP_FOLDER`).
      '';
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        API_DOCS_ENABLED = "true";
        DISK_TYPE = "LOCAL";
      };
      description = "Extra environment variables to pass to Grimmory.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        Path to an `EnvironmentFile` for secrets that shouldn't be added to the
        Nix store. Must at least set `DATABASE_PASSWORD`, since Grimmory
        always connects to its database over TCP/JDBC.
      '';
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to create a local MariaDB database and user for Grimmory via `services.mysql`.";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "Database host (`DATABASE_HOST`).";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 3306;
        description = "Database port (`DATABASE_PORT`).";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "grimmory";
        description = "Database name (`DATABASE_NAME`).";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "grimmory";
        description = "Database user (`DATABASE_USERNAME`).";
      };
    };

    nginx = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.submodule {
          options = {
            hostName = lib.mkOption {
              type = lib.types.str;
              description = "Nginx virtual host name to serve Grimmory on.";
            };

            extraConfig = lib.mkOption {
              type = lib.types.attrsOf lib.types.anything;
              default = { };
              description = ''
                Extra configuration merged into the generated
                `services.nginx.virtualHosts.<hostName>` entry.
              '';
            };
          };
        }
      );
      default = null;
      description = "If set, configure an Nginx virtual host reverse-proxying to Grimmory.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.createLocally -> cfg.database.host == "localhost";
        message = "services.grimmory.database.host must be \"localhost\" if services.grimmory.database.createLocally is set to true.";
      }
    ];

    services.mysql = lib.mkIf cfg.database.createLocally {
      enable = true;
      package = lib.mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    services.nginx = lib.mkIf (cfg.nginx != null) {
      enable = true;
      virtualHosts.${cfg.nginx.hostName} = lib.recursiveUpdate {
        locations."/" = {
          proxyPass = "http://${cfg.host}:${toString cfg.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      } cfg.nginx.extraConfig;
    };

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };

    users.groups.${cfg.group} = { };

    systemd.services.grimmory-db-password = lib.mkIf cfg.database.createLocally {
      description = "Set the local MariaDB password for Grimmory";
      after = [ "mysql.service" ];
      requires = [ "mysql.service" ];
      before = [ "grimmory.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        EnvironmentFile = cfg.environmentFile;
      };

      script = ''
        if [ -z "$DATABASE_PASSWORD" ]; then
          echo "DATABASE_PASSWORD is empty or unset; check services.grimmory.environmentFile" >&2
          exit 1
        fi

        escaped_password="$(printf '%s' "$DATABASE_PASSWORD" | sed "s/'/'''/g")"

        ${lib.getExe' config.services.mysql.package "mysql"} <<EOF
        SET sql_mode = 'NO_BACKSLASH_ESCAPES';
        ALTER USER '${cfg.database.user}'@'localhost' IDENTIFIED BY '$escaped_password';
        FLUSH PRIVILEGES;
        EOF
      '';
    };

    systemd.services.grimmory = {
      description = "Grimmory, a self-hosted digital library for EPUB, PDF and comics";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [
        "network-online.target"
      ]
      ++ lib.optionals cfg.database.createLocally [
        "mysql.service"
        "grimmory-db-password.service"
      ];
      requires = lib.optionals cfg.database.createLocally [
        "mysql.service"
        "grimmory-db-password.service"
      ];

      environment = {
        SERVER_ADDRESS = cfg.host;
        BOOKLORE_PORT = toString cfg.port;
        APP_PATH_CONFIG = cfg.dataDir;
        APP_BOOKDROP_FOLDER = cfg.bookdropDir;
        DATABASE_HOST = cfg.database.host;
        DATABASE_PORT = toString cfg.database.port;
        DATABASE_NAME = cfg.database.name;
        DATABASE_USERNAME = cfg.database.user;
      }
      // cfg.environment;

      serviceConfig = {
        Type = "simple";
        ExecStart = lib.getExe cfg.package;
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        StateDirectory = "grimmory";
        EnvironmentFile = cfg.environmentFile;

        Restart = "on-failure";
        RestartSec = "5s";
        TimeoutStartSec = "120s";

        CapabilityBoundingSet = "";
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
        ReadWritePaths = [
          cfg.dataDir
          cfg.booksDir
          cfg.bookdropDir
        ];
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ alvr ];
}
