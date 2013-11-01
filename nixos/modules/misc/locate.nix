{ config, pkgs, ... }:

with pkgs.lib;

let

  locatedb = "/var/cache/locatedb";

in

{

  ###### interface

  options = {

    services.locate = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If enabled, NixOS will periodically update the database of
          files used by the <command>locate</command> command.
        '';
      };

      period = mkOption {
        type = types.str;
        default = "15 02 * * *";
        description = ''
          This option defines (in the format used by cron) when the
          locate database is updated.
          The default is to update at 02:15 at night every day.
        '';
      };

    };

  };

  ###### implementation

  config = {

    systemd.services.update-locatedb =
      { description = "Update Locate Database";
        path  = [ pkgs.su ];
        script =
          ''
            mkdir -m 0755 -p $(dirname ${locatedb})
            exec updatedb --localuser=nobody --output=${locatedb} --prunepaths='/tmp /var/tmp /media /run'
          '';
        serviceConfig.Nice = 19;
        serviceConfig.IOSchedulingClass = "idle";
      };

    services.cron.systemCronJobs = optional config.services.locate.enable
      "${config.services.locate.period} root ${config.systemd.package}/bin/systemctl start update-locatedb.service";

  };

}
