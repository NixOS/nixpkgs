{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nezha-agent;
in
{
  meta = {
    maintainers = with lib.maintainers; [ moraxyc ];
  };
  options = {
    services.nezha-agent = {
      enable = lib.mkEnableOption "Agent of Nezha Monitoring";

      package = lib.mkPackageOption pkgs "nezha-agent" { };
      debug = lib.mkEnableOption "verbose log";
      tls = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable SSL/TLS encryption.
        '';
      };
      disableCommandExecute = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Disable executing the command from dashboard.
        '';
      };
      skipConnection = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Do not monitor the number of connections.
        '';
      };
      skipProcess = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Do not monitor the number of processes.
        '';
      };
      reportDelay = lib.mkOption {
        type = lib.types.enum [ 1 2 3 4 ];
        default = 1;
        description = ''
          The interval between system status reportings.
          The value must be an integer from 1 to 4
        '';
      };
      passwordFile = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Path to the file contained the password from dashboard.
        '';
      };
      server = lib.mkOption {
        type = lib.types.str;
        description = ''
          Address to the dashboard
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];

    systemd.services.nezha-agent = {
      serviceConfig = {
        ProtectSystem = "full";
        PrivateDevices = "yes";
        PrivateTmp = "yes";
        NoNewPrivileges = true;
      };
      path = [ cfg.package ];
      startLimitIntervalSec = 10;
      startLimitBurst = 3;
      script = lib.concatStringsSep " " (
        [
          "${cfg.package}/bin/agent"
          "--disable-auto-update"
          "--disable-force-update"
          "--password $(cat ${cfg.passwordFile})"
        ]
        ++ lib.optional cfg.debug "--debug"
        ++ lib.optional cfg.disableCommandExecute "--disable-command-execute"
        ++ lib.optional (cfg.reportDelay != null) "--report-delay ${toString cfg.reportDelay}"
        ++ lib.optional (cfg.server != null) "--server ${cfg.server}"
        ++ lib.optional cfg.skipConnection "--skip-conn"
        ++ lib.optional cfg.skipProcess "--skip-procs"
        ++ lib.optional cfg.tls "--tls"
      );
      wantedBy = [ "multi-user.target" ];
    };
  };
}
