{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.logrotate;

  configFile = pkgs.writeText "logrotate.conf"
    cfg.config;

in
{
  options = {
    services.logrotate = {
      enable = mkOption {
        default = false;
        description = ''
          Enable the logrotate cron job
        '';
      };

      config = mkOption {
        default = "";
        description = ''
          The contents of the logrotate config file
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.logrotate = {
      description   = "Logrotate Service";
      wantedBy      = [ "multi-user.target" ];
      startAt       = "*-*-* *:05:00";

      serviceConfig.Restart = "no";
      serviceConfig.User    = "root";
      script = ''
        exec ${pkgs.logrotate}/sbin/logrotate ${configFile}
      '';
    };
  };
}
