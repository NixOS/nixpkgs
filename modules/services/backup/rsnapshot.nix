{ config, pkgs, ... }:

with pkgs.lib;

let cfg = config.services.rsnapshot;
in
{
  options = {
    services.rsnapshot = {
      enable = mkEnableOption "rsnapshot backups";

      configuration = mkOption {
        default = "";
        example = ''
          retain hourly 24
          retain daily 365
          backup /home/ localhost/
        '';
        type = types.lines;
        description = ''
        rsnapshot configuration option in addition to the defaults from rsnapshot and this module.
        '';
      };

      cronIntervals = mkOption {
        default = {};
        example = { "hourly" = "0 * * * *"; "daily" = "50 21 * * *"; };
        type = types.attrsOf types.string;
        description = ''
        Periodicity at which intervals should be run by cron.
        Note that the intervals also have to exist in configuration
        as retain options.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.rsnapshot ];

    services.cron.systemCronJobs =
      mapAttrsToList (interval: time: "${time} root ${pkgs.rsnapshot}/bin/rsnapshot ${interval}") cfg.cronIntervals;

    environment.etc."rsnapshot.conf".source = with pkgs; writeText "gen-rsnapshot.conf" (''
        config_version	1.2
        cmd_cp	${coreutils}/bin/cp
        cmd_rsync	${rsync}/bin/rsync
        cmd_ssh	${openssh}/bin/ssh
        cmd_logger	${inetutils}/bin/logger
        cmd_du	${coreutils}/bin/du
        cmd_rsnapshot_diff	${rsnapshot}/bin/rsnapshot-diff
        lockfile	/run/rsnapshot.pid

      '' + cfg.configuration);
  };
}
