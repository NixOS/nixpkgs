{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.locate;
in {

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

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Extra flags to append to <command>updatedb</command>.
        '';
      };

      output = mkOption {
        type = types.path;
        default = /var/cache/locatedb;
        description = ''
          The database file to build.
        '';
      };

      localuser = mkOption {
        type = types.str;
        default = "nobody";
        description = ''
          The user to search non-network directories as, using
          <command>su</command>.
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
            mkdir -m 0755 -p $(dirname ${toString cfg.output})
            exec updatedb \
            --localuser=${cfg.localuser} \
            --output=${toString cfg.output} ${concatStringsSep " " cfg.extraFlags}
          '';
        serviceConfig.Nice = 19;
        serviceConfig.IOSchedulingClass = "idle";
      };

    services.cron.systemCronJobs = optional config.services.locate.enable
      "${config.services.locate.period} root ${config.systemd.package}/bin/systemctl start update-locatedb.service";

  };

}
