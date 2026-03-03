{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.jelu;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "application.yml" cfg.settings;
in
{
  options.services.jelu = {
    enable = lib.mkEnableOption "Jelu book tracking service";

    package = lib.mkPackageOption pkgs "jelu" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "jelu";
      description = "User account under which Jelu runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "jelu";
      description = "Group under which Jelu runs.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/jelu";
      description = "Directory to store Jelu database and files.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open ports in the firewall for Jelu.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 11111;
      description = "Port on which Jelu listens.";
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        File containing environment variables to be passed to the Jelu service.
        Useful for passing secrets like `SPRING_DATASOURCE_PASSWORD` or LDAP credentials.
      '';
    };

    calibreSupport = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable Calibre metadata fetching support.
        Note: This pulls in the full Calibre package which is large.
      '';
    };

    settings = lib.mkOption {
      description = ''
        Configuration for Jelu, written to `application.yml`.
        Refer to the [upstream documentation](https://bayang.github.io/jelu-web/)
        for available options.
      '';
      default = { };
      example = lib.literalExpression ''
        {
          jelu.cors.allowed-origins = [ "https://jelu.example.com" ];
        }
      '';
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          server.port = lib.mkOption {
            type = lib.types.port;
            description = "Port Jelu listens on. Defaults to {option}`services.jelu.port`.";
          };

          jelu = {
            database.path = lib.mkOption {
              type = lib.types.str;
              description = "Path to the Jelu database directory. Defaults to a subdirectory of {option}`services.jelu.dataDir`.";
            };

            files = {
              images = lib.mkOption {
                type = lib.types.str;
                description = "Path to the Jelu images directory.";
              };
              imports = lib.mkOption {
                type = lib.types.str;
                description = "Path to the Jelu imports directory.";
              };
            };

            session.duration = lib.mkOption {
              type = lib.types.int;
              default = 604800;
              description = "Session duration in seconds.";
            };

            cors.allowed-origins = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              description = "List of CORS allowed origins.";
            };
          };

          spring = {
            datasource = {
              url = lib.mkOption {
                type = lib.types.str;
                description = "JDBC datasource URL. Defaults to an SQLite database inside {option}`services.jelu.dataDir`.";
              };

              driver-class-name = lib.mkOption {
                type = lib.types.str;
                default = "org.sqlite.JDBC";
                description = "JDBC driver class name.";
              };

              username = lib.mkOption {
                type = lib.types.str;
                default = "jelu_user";
                description = "Database username.";
              };

              password = lib.mkOption {
                type = lib.types.str;
                default = "mypass1234";
                description = ''
                  Database password. This is the upstream default for SQLite and
                  is effectively unused for local SQLite databases.
                  For production use, consider setting this via
                  {option}`services.jelu.environmentFile` using `SPRING_DATASOURCE_PASSWORD`.
                '';
              };
            };

            jpa.database-platform = lib.mkOption {
              type = lib.types.str;
              default = "org.hibernate.community.dialect.SQLiteDialect";
              description = "Hibernate dialect for the database platform.";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.jelu.settings = {
      server.port = lib.mkDefault cfg.port;
      jelu = {
        database.path = lib.mkDefault "${cfg.dataDir}/database";
        files = {
          images = lib.mkDefault "${cfg.dataDir}/files/images";
          imports = lib.mkDefault "${cfg.dataDir}/files/imports";
        };
        cors.allowed-origins = lib.mkDefault [ "http://localhost:${toString cfg.port}" ];
      }
      // lib.optionalAttrs cfg.calibreSupport {
        metadata.calibre.path = "${pkgs.calibre}/bin/fetch-ebook-metadata";
      };
      # Overriding jelu.database.path requires updating this URL accordingly.
      spring.datasource.url = lib.mkDefault "jdbc:sqlite:${cfg.dataDir}/database/jelu.db";
    };

    users.users = lib.mkIf (cfg.user == "jelu") {
      jelu = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
        createHome = true;
        description = "Jelu service user";
      };
    };

    users.groups = lib.mkIf (cfg.group == "jelu") {
      jelu = { };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    systemd.tmpfiles.settings."10-jelu" = {
      "${cfg.settings.jelu.database.path}".d = {
        user = cfg.user;
        group = cfg.group;
        mode = "0750";
      };
      "${cfg.dataDir}/files".d = {
        user = cfg.user;
        group = cfg.group;
        mode = "0750";
      };
      "${cfg.settings.jelu.files.images}".d = {
        user = cfg.user;
        group = cfg.group;
        mode = "0750";
      };
      "${cfg.settings.jelu.files.imports}".d = {
        user = cfg.user;
        group = cfg.group;
        mode = "0750";
      };
    };

    systemd.services.jelu = {
      description = "Jelu book tracking service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        HOME = cfg.dataDir;
        SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
      }
      // lib.optionalAttrs cfg.calibreSupport {
        QTWEBENGINE_DISABLE_SANDBOX = "1";
        QT_QPA_PLATFORM = "offscreen";
        QTWEBENGINE_CHROMIUM_FLAGS = "--disable-gpu";
        XDG_CONFIG_HOME = "${cfg.dataDir}/.config";
        XDG_CACHE_HOME = "${cfg.dataDir}/.cache";
      };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "jelu";
        StateDirectoryMode = "0750";
        WorkingDirectory = cfg.dataDir;
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;
        ExecStart = "${lib.getExe cfg.package} --spring.config.additional-location=file:${configFile}";
        Restart = "on-failure";
        RestartSec = "10s";

        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ cfg.dataDir ];
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = false; # Java requires this to be false due to JIT
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        ProtectClock = true;
        SystemCallArchitectures = "native";
        ProtectHostname = true;
        ProtectKernelLogs = true;
        RemoveIPC = true;
        UMask = "0077";
        SystemCallFilter = [
          "~@clock"
          "~@cpu-emulation"
          "~@debug"
          "~@module"
          "~@mount"
          "~@obsolete"
          "~@raw-io"
          "~@reboot"
          "~@swap"
        ];
      };
    };

    meta = {
      maintainers = with lib.maintainers; [ m0streng0 ];
    };
  };
}
