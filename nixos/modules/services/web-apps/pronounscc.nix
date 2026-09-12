{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.pronounscc;

  environment = lib.mapAttrs (
    _: value: if lib.isBool value then lib.boolToString value else toString value
  ) cfg.settings;

  dependencies = [
    "postgresql.service"
    "redis.service"
  ];

  serviceConfig = {
    DynamicUser = true;
    CapabilityBoundingSet = "";
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateTmp = true;
    ProtectHome = true;
    ProtectSystem = "strict";
    RestartSec = 2;
  };

  backendServiceConfig = serviceConfig // {
    EnvironmentFile = cfg.environmentFiles;
  };
in
{
  options.services.pronounscc = {
    enable = lib.mkEnableOption "pronouns.cc";

    package = lib.mkPackageOption pkgs "pronounscc" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (oneOf [
            bool
            int
            str
          ]);

        options = {
          PORT = lib.mkOption {
            type = lib.types.port;
            default = 8080;
            description = "Port on which the API listens.";
          };

          EXPORTER_PORT = lib.mkOption {
            type = lib.types.port;
            default = 9090;
            description = "Port on which the data exporter listens.";
          };
        };
      };
      default = { };
      example = {
        BASE_URL = "https://pronouns.example.com";
        DATABASE_URL = "postgresql:///pronounscc?host=/run/postgresql";
        REDIS = "127.0.0.1:6379";
        MINIO_ENDPOINT = "s3.example.com";
        MINIO_BUCKET = "pronounscc";
      };
      description = ''
        Environment variables for pronouns.cc. See
        <https://codeberg.org/pronounscc/pronouns.cc/src/branch/main/docs/self-hosting.md#backend-keys>.
      '';
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = [ "/run/secrets/pronounscc" ];
      description = "Files containing environment variables, including secrets.";
    };

    enableFrontend = lib.mkEnableOption "the pronouns.cc frontend" // {
      default = true;
    };

    frontendPort = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "Port on which the frontend listens.";
    };

    enableExporter = lib.mkEnableOption "the pronouns.cc data exporter" // {
      default = true;
    };

    enableDatabaseCleaning = lib.mkEnableOption "daily pronouns.cc database cleaning" // {
      default = true;
    };

    openFirewall = lib.mkEnableOption "opening the configured TCP ports";
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall (
      [ cfg.settings.PORT ]
      ++ lib.optional cfg.enableFrontend cfg.frontendPort
      ++ lib.optional cfg.enableExporter cfg.settings.EXPORTER_PORT
    );

    systemd.services = {
      pronounscc = {
        description = "pronouns.cc API";
        after = [ "network-online.target" ] ++ dependencies;
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        inherit environment;

        serviceConfig = backendServiceConfig // {
          ExecStartPre = "${lib.getExe cfg.package} database migrate";
          ExecStart = "${lib.getExe cfg.package} web";
          Restart = "on-failure";
        };
      };

      pronounscc-frontend = lib.mkIf cfg.enableFrontend {
        description = "pronouns.cc frontend";
        after = [ "pronounscc.service" ];
        requires = [ "pronounscc.service" ];
        wantedBy = [ "multi-user.target" ];
        environment.PORT = toString cfg.frontendPort;

        serviceConfig = serviceConfig // {
          ExecStart = lib.getExe' cfg.package "pronounscc-frontend";
          WorkingDirectory = "${cfg.package}/share/pronounscc/frontend";
          Restart = "on-failure";
        };
      };

      pronounscc-exporter = lib.mkIf cfg.enableExporter {
        description = "pronouns.cc data exporter";
        after = [ "network-online.target" ] ++ dependencies;
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        inherit environment;

        serviceConfig = backendServiceConfig // {
          ExecStart = "${lib.getExe cfg.package} exporter";
          Restart = "on-failure";
        };
      };

      pronounscc-clean = lib.mkIf cfg.enableDatabaseCleaning {
        description = "Clean the pronouns.cc database";
        after = [ "network-online.target" ] ++ dependencies;
        wants = [ "network-online.target" ];
        inherit environment;

        serviceConfig = backendServiceConfig // {
          Type = "oneshot";
          ExecStart = "${lib.getExe cfg.package} database clean";
        };
      };
    };

    systemd.timers.pronounscc-clean = lib.mkIf cfg.enableDatabaseCleaning {
      description = "Daily pronouns.cc database cleaning";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ philocalyst ];
}
