{config, pkgs, ...}:

with pkgs.lib;

let
  cfg = config.services.logrotate;

  configFile = pkgs.writeText "logrotate.conf"
    cfg.config;

  cronJob = ''
    5 * * * * ${pkgs.logrotate}/sbin/logrotate ${configFile}
  '';

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
    services.cron.systemCronJobs = [ cronJob ];
  };
}
