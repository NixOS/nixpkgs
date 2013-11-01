{ config, pkgs, ... }:

with pkgs.lib;

let cfg = config.services.rsnapshot;
in
{
  options = {
    services.rsnapshot = {
      enable = mkEnableOption "rsnapshot backups";

      extraConfig = mkOption {
        default = "";
        example = ''
          retains	hourly	24
          retain	daily	365
          backup	/home/	localhost/
        '';
        type = types.lines;
        description = ''
          rsnapshot configuration option in addition to the defaults from
          rsnapshot and this module.

          Note that tabs are required to separate option arguments, and
          directory names require trailing slashes.

          The "extra" in the option name might be a little misleading right
          now, as it is required to get a functional configuration.
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

  config = mkIf cfg.enable (let
    myRsnapshot = pkgs.rsnapshot.override { configFile = rsnapshotCfg; };
    rsnapshotCfg = with pkgs; writeText "gen-rsnapshot.conf" (''
        config_version	1.2
        cmd_cp	${coreutils}/bin/cp
        cmd_rsync	${rsync}/bin/rsync
        cmd_ssh	${openssh}/bin/ssh
        cmd_logger	${inetutils}/bin/logger
        cmd_du	${coreutils}/bin/du
        lockfile	/run/rsnapshot.pid

        ${cfg.extraConfig}
      '');
    in {
      environment.systemPackages = [ myRsnapshot ];

      services.cron.systemCronJobs =
        mapAttrsToList (interval: time: "${time} root ${myRsnapshot}/bin/rsnapshot ${interval}") cfg.cronIntervals;
    }
  );
}
