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
      type = settingsFormat.type;
      default = { };
      description = ''
        Configuration for Jelu.
        The result is generated as an `application.yml` file.
      '';
      example = lib.literalExpression ''
        {
          jelu = {
            cors.allowed-origins = [ "https://jelu.example.com" ];
          };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.jelu.settings = {
      server.port = cfg.port;
      jelu = {
        database.path = "${cfg.dataDir}/database";
        files = {
          images = "${cfg.dataDir}/files/images";
          imports = "${cfg.dataDir}/files/imports";
        };
        session = {
          duration = lib.mkDefault 604800; # 7 days in seconds
        };
        cors.allowed-origins = lib.mkDefault [ "http://localhost:${toString cfg.port}" ];
      }
      // lib.optionalAttrs cfg.calibreSupport {
        metadata.calibre.path = "${pkgs.calibre}/bin/fetch-ebook-metadata";
      };

      spring.datasource = {
        url = "jdbc:sqlite:${cfg.dataDir}/database/jelu.db";
        driver-class-name = "org.sqlite.JDBC";
        username = "jelu_user"; # Default from Jelu docs
        password = "mypass1234"; # Default from Jelu docs
      };
      spring.jpa.database-platform = "org.hibernate.community.dialect.SQLiteDialect";
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

    systemd.services.jelu = {
      description = "Jelu book tracking service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        HOME = cfg.dataDir;
      }
      // lib.optionalAttrs cfg.calibreSupport {
        QTWEBENGINE_DISABLE_SANDBOX = "1";
        QT_QPA_PLATFORM = "offscreen";
        QTWEBENGINE_CHROMIUM_FLAGS = "--disable-gpu";
        XDG_CONFIG_HOME = "${cfg.dataDir}/.config";
        XDG_CACHE_HOME = "${cfg.dataDir}/.cache";
      };

      preStart = ''
        mkdir -p "${cfg.dataDir}/database"
        mkdir -p "${cfg.dataDir}/files/images"
        mkdir -p "${cfg.dataDir}/files/imports"
      '';

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
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = false; # Java requires this to be false due to JIT
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        ProtectClock = true;
      };
    };

    meta = {
      maintainers = with lib.maintainers; [ m0streng0 ];
    };
  };
}
