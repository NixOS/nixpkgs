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
              0) initctl start shutdown --no-wait MODE=poweroff;;
              1) initctl start shutdown --no-wait MODE=maintenance;;
              6) initctl start shutdown --no-wait MODE=reboot;;
              *) echo "Unsupported runlevel: $RUNLEVEL";;
          esac
        '';
    };

}
