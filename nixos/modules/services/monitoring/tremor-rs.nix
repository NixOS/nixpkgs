{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.services.tremor-rs;

  loggerSettingsFormat = pkgs.formats.yaml { };
  loggerConfigFile = loggerSettingsFormat.generate "logger.yaml" cfg.loggerSettings;
in {

  options = {
    services.tremor-rs = {
      enable = lib.mkEnableOption (lib.mdDoc "Tremor event- or stream-processing system");

      troyFileList = mkOption {
        type = types.listOf types.path;
        default = [];
        description = lib.mdDoc "List of troy files to load.";
      };

      tremorLibDir = mkOption {
        type = types.path;
        default = "";
        description = lib.mdDoc "Directory where to find /lib containing tremor script files";
      };

      host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = lib.mdDoc "The host tremor should be listening on";
      };

      port = mkOption {
        type = types.port;
        default = 9898;
        description = lib.mdDoc "the port tremor should be listening on";
      };

      loggerSettings = mkOption {
        description = lib.mdDoc "Tremor logger configuration";
        default = {};
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

        defaultText = literalExpression ''
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

  config = mkIf (cfg.enable) {

    environment.systemPackages = [ pkgs.tremor-rs ] ;

    systemd.services.tremor-rs = {
      description = "Tremor event- or stream-processing system";
      wantedBy = [ "multi-user.target" ];
      requires = [ "network-online.target" ];
      after = [ "network-online.target" ];

      environment.TREMOR_PATH = "${pkgs.tremor-rs}/lib:${cfg.tremorLibDir}";

      serviceConfig = {
        ExecStart = "${pkgs.tremor-rs}/bin/tremor --logger-config ${loggerConfigFile} server run ${concatStringsSep " " cfg.troyFileList} --api-host ${cfg.host}:${toString cfg.port}";
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
        SystemCallFilter = [ "@system-service" "~@privileged" ];
      };
    };
  };
}
