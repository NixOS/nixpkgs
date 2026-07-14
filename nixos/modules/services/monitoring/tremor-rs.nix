{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.tremor-rs;

  loggerSettingsFormat = pkgs.formats.yaml { };
  loggerConfigFile = loggerSettingsFormat.generate "logger.yaml" cfg.loggerSettings;
in
{

  options = {
    services.tremor-rs = {
      enable = lib.mkEnableOption "Tremor event- or stream-processing system";

      troyFileList = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = "List of troy files to load.";
      };

      tremorLibDir = lib.mkOption {
        type = lib.types.path;
        default = "";
        description = "Directory where to find /lib containing tremor script files";
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "The host tremor should be listening on";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 9898;
        description = "the port tremor should be listening on";
      };

      loggerSettings = lib.mkOption {
        description = "Tremor logger configuration";
        default = { };
        type = loggerSettingsFormat.type;

        example = {
          refresh_rate = "30 seconds";
          appenders.stdout.kind = "console";
          root = {
            level = "warn";
            appenders = [ "stdout" ];
          };
          loggers = {
            tremor_runtime = {
              level = "debug";
              appenders = [ "stdout" ];
              additive = false;
            };
            tremor = {
              level = "debug";
              appenders = [ "stdout" ];
              additive = false;
            };
          };
        };

        defaultText = lib.literalExpression ''
          {
            refresh_rate = "30 seconds";
            appenders.stdout.kind = "console";
            root = {
              level = "warn";
              appenders = [ "stdout" ];
            };
            loggers = {
              tremor_runtime = {
                level = "debug";
                appenders = [ "stdout" ];
                additive = false;
              };
              tremor = {
                level = "debug";
                appenders = [ "stdout" ];
                additive = false;
              };
            };
          }
        '';

      };
    };
  };

  config = lib.mkIf (cfg.enable) {

    environment.systemPackages = [ pkgs.tremor-rs ];

    systemd.services.tremor-rs = {
      description = "Tremor event- or stream-processing system";
      wantedBy = [ "multi-user.target" ];
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];

      environment.TREMOR_PATH = "${pkgs.tremor-rs}/lib:${cfg.tremorLibDir}";

      serviceConfig = {
        ExecStart = "${pkgs.tremor-rs}/bin/tremor --logger-config ${loggerConfigFile} server run ${lib.concatStringsSep " " cfg.troyFileList} --api-host ${cfg.host}:${toString cfg.port}";
        DynamicUser = true;
        Restart = "always";
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
        ProtectClock = true;
        ProtectProc = "noaccess";
        ProcSubset = "pid";
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        RestrictSUIDSGID = true;
        RestrictRealtime = true;
        RestrictNamespaces = true;
        LockPersonality = true;
        RemoveIPC = true;
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
      };
    };
  };
}
