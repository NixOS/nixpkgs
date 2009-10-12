{ config, pkgs, ... }:

###### implementation

{
  jobAttrs.maintenance_shell =
    { name = "maintenance-shell";

      startOn = [ "maintenance" "stalled" ];

      task = true;

      script =
        ''
          exec < /dev/tty1 > /dev/tty1 2>&1
          echo \
          echo "<<< MAINTENANCE SHELL >>>"
          echo ""
          exec ${pkgs.bash}/bin/sh
        '';
    };
}
