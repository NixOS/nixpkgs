{ config, lib, pkgs, ... }:

with lib;

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

      hours = mkOption {
        type = types.int;
        default = 24;
        description = ''
          This option defines, in hours, when the locate database is updated.
          The default is to update 24 hours after the last update.
        '';
      };

    };

  };

  ###### implementation

  config = {

    systemd.services.update-locatedb = {
      description = "Update Locate Database";
      path  = [ pkgs.su ];
      script = ''
        mkdir -m 0755 -p $(dirname ${locatedb})
        exec updatedb --localuser=nobody --output=${locatedb} --prunepaths='/tmp /var/tmp /media /run'
      '';
      serviceConfig.Nice = 19;
      serviceConfig.IOSchedulingClass = "idle";
    };
    systemd.timers.update-locatedb = {
      timerConfig.OnUnitInactiveSec = 3600 * config.services.locate.hours;
    };

  };

}
