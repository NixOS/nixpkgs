{ config, pkgs, ... }:

with pkgs.lib;

{

  jobs.runlevel =
    { name = "runlevel";

      startOn = "runlevel [0123456S]";

      task = true;

      script =
        ''
          case "$RUNLEVEL" in
              0) initctl start shutdown MODE=poweroff;;
              1) initctl start shutdown MODE=maintenance;;
              6) initctl start shutdown MODE=reboot;;
              *) echo "Unsupported runlevel: $RUNLEVEL";;
          esac
        '';
    };

}
