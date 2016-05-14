{ config, lib, pkgs, ... }:

with lib;

let 
  cfg = config.services.rsnapshot;
  cfgfile = pkgs.writeText "rsnapshot.conf" ''
    config_version	1.2
    cmd_cp	${pkgs.coreutils}/bin/cp
    cmd_rsync	${pkgs.rsync}/bin/rsync
    cmd_ssh	${pkgs.openssh}/bin/ssh
    cmd_logger	${pkgs.inetutils}/bin/logger
    cmd_du	${pkgs.coreutils}/bin/du
    lockfile	/run/rsnapshot.pid

    ${cfg.extraConfig}
  '';
in
{
  options = {
    services.rsnapshot = {
      enable = mkEnableOption "rsnapshot backups";
      enableManualRsnapshot = mkOption {
        description = "Whether to enable manual usage of the rsnapshot command with this module.";
        default = true;
        example = false;
        type = types.bool;
      };

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
        example = { hourly = "0 * * * *"; daily = "50 21 * * *"; };
        type = types.attrsOf types.string;
        description = ''
          Periodicity at which intervals should be run by cron.
          Note that the intervals also have to exist in configuration
          as retain options.
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.cron.systemCronJobs =
        mapAttrsToList (interval: time: "${time} root ${pkgs.rsnapshot}/bin/rsnapshot -c ${cfgfile} ${interval}") cfg.cronIntervals;
    }
    (mkIf cfg.enableManualRsnapshot {
      environment.systemPackages = [ pkgs.rsnapshot ];
      environment.etc."rsnapshot.conf".source = cfgfile;
    })
  ]);
}
