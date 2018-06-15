{ config, lib, pkgs, ... }:

with builtins;
with lib;

let
  cfg = config.services.osquery;

in

{

  options = {

    services.osquery = {

      enable = mkEnableOption "osquery";

      loggerPath = mkOption {
        type = types.path;
        description = "Base directory used for logging.";
        default = "/var/log/osquery";
      };

      pidfile = mkOption {
        type = types.path;
        description = "Path used for pid file.";
        default = "/var/osquery/osqueryd.pidfile";
      };

      utc = mkOption {
        type = types.bool;
        description = "Attempt to convert all UNIX calendar times to UTC.";
        default = true;
      };

      databasePath = mkOption {
        type = types.path;
        description = "Path used for database file.";
        default = "/var/osquery/osquery.db";
      };

      extraConfig = mkOption {
        type = types.attrs // {
          merge = loc: foldl' (res: def: recursiveUpdate res def.value) {};
        };
        description = "Extra config to be recursively merged into the JSON config file.";
        default = { };
      };
    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.osquery ];

    environment.etc."osquery/osquery.conf".text = toJSON (
      recursiveUpdate {
        options = {
          config_plugin = "filesystem";
          logger_plugin = "filesystem";
          logger_path = cfg.loggerPath;
          database_path = cfg.databasePath;
          utc = cfg.utc;
        };
      } cfg.extraConfig
    );

    systemd.services.osqueryd = {
      description = "The osquery Daemon";
      after = [ "network.target" "syslog.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.osquery ];
      preStart = ''
        mkdir -p ${escapeShellArg cfg.loggerPath}
        mkdir -p "$(dirname ${escapeShellArg cfg.pidfile})"
        mkdir -p "$(dirname ${escapeShellArg cfg.databasePath})"
      '';
      serviceConfig = {
        TimeoutStartSec = 0;
        ExecStart = "${pkgs.osquery}/bin/osqueryd --logger_path ${escapeShellArg cfg.loggerPath} --pidfile ${escapeShellArg cfg.pidfile} --database_path ${escapeShellArg cfg.databasePath}";
        KillMode = "process";
        KillSignal = "SIGTERM";
        Restart = "on-failure";
      };
    };

  };

}
