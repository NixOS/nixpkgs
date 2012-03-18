{ config, pkgs, ... }:

with pkgs.lib;

{

  # After booting, go to runlevel 2.  (NixOS doesn't really use
  # runlevels, but this keeps wtmp happy.)
  jobs.boot =
    { name = "boot";
      startOn = "startup";
      task = true;
      restartIfChanged = false;
      script = "telinit 2";
    };

  jobs.runlevel =
    { name = "runlevel";

      startOn = "runlevel [0123456S]";

      task = true;

      restartIfChanged = false;
      
      script =
        ''
          case "$RUNLEVEL" in
              0) initctl start shutdown --no-wait MODE=poweroff;;
              1) initctl start shutdown --no-wait MODE=maintenance;;
              2) true;;
              6) initctl start shutdown --no-wait MODE=reboot;;
              *) echo "Unsupported runlevel: $RUNLEVEL";;
          esac
        '';
    };

}
