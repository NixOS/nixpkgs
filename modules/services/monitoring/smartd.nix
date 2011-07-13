{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.smartd;

in

{
  ###### interface

  options = {

    services.smartd = {

      enable = mkOption {
        default = false;
        type = types.bool;
        example = "true";
        description = ''
          Run smartd from the smartmontools package.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    jobs.smartd =
      { description = "S.M.A.R.T. Daemon";

        startOn = "started syslogd";

        daemonType = "daemon";

        exec = "${pkgs.smartmontools}/sbin/smartd";
      };

  };

}
