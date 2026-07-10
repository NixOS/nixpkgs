{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.ferretdb;
in
{

  meta.maintainers = with lib.maintainers; [
    julienmalka
    camillemndn
  ];

  options = {
    services.ferretdb = {
      enable = lib.mkEnableOption "FerretDB, an Open Source MongoDB alternative";

      package = lib.mkPackageOption pkgs "ferretdb" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = with lib.types; attrsOf str;
          options = {
            FERRETDB_HANDLER = lib.mkOption {
              type = lib.types.enum [
                "sqlite"
                "pg"
              ];
              default = "sqlite";
              description = "Backend handler";
            };

            FERRETDB_SQLITE_URL = lib.mkOption {
              type = lib.types.str;
              default = "file:/var/lib/ferretdb/";
              description = "SQLite URI (directory) for 'sqlite' handler";
            };

            FERRETDB_POSTGRESQL_URL = lib.mkOption {
              type = lib.types.str;
              default = "postgres://ferretdb@localhost/ferretdb?host=/run/postgresql";
              description = "PostgreSQL URL for 'pg' handler";
            };

            FERRETDB_TELEMETRY = lib.mkOption {
              type = lib.types.enum [
                "enable"
                "disable"
              ];
              default = "disable";
              description = ''
                Enable or disable basic telemetry.

                See <https://docs.ferretdb.io/telemetry/> for more information.
              '';
            };
          };
        };
        example = {
          FERRETDB_LOG_LEVEL = "warn";
          FERRETDB_MODE = "normal";
        };
        description = ''
          Additional configuration for FerretDB, see
          <https://docs.ferretdb.io/configuration/flags/>
          for supported values.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.ferretdb.settings = { };

    systemd.services.ferretdb = {
      description = "FerretDB";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.settings;
      serviceConfig = {
        Type = "simple";
        StateDirectory = "ferretdb";
        WorkingDirectory = "/var/lib/ferretdb";
        ExecStart = "${cfg.package}/bin/ferretdb";
        Restart = "on-failure";
        ProtectHome = true;
        ProtectSystem = "strict";
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        NoNewPrivileges = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        PrivateMounts = true;
        DynamicUser = true;
      };
    };
  };
}
