{ config, lib, pkgs, ... }:

with lib;

let

  enabled = elem "displaylink" config.services.xserver.videoDrivers;

  evdi = config.boot.kernelPackages.evdi;

  displaylink = pkgs.displaylink.override {
    inherit evdi;
  };

in

{

  config = mkIf enabled {

    boot.extraModulePackages = [ evdi ];

    # Those are taken from displaylink-installer.sh and from Arch Linux AUR package.

    services.udev.packages = [ displaylink ];

    powerManagement.powerDownCommands = ''
      #flush any bytes in pipe
      while read -n 1 -t 1 SUSPEND_RESULT < /tmp/PmMessagesPort_out; do : ; done;

      #suspend DisplayLinkManager
      echo "S" > /tmp/PmMessagesPort_in

      #wait until suspend of DisplayLinkManager finish
      if [ -f /tmp/PmMessagesPort_out ]; then
        #wait until suspend of DisplayLinkManager finish
        read -n 1 -t 10 SUSPEND_RESULT < /tmp/PmMessagesPort_out
      fi
    '';

    powerManagement.resumeCommands = ''
      #resume DisplayLinkManager
      echo "R" > /tmp/PmMessagesPort_in
    '';

    systemd.services.dlm = {
      description = "DisplayLink Manager Service";
      after = [ "display-manager.service" ];
      conflicts = [ "getty@tty7.service" ];
      path = [ pkgs.kmod ];

      serviceConfig = {
        ExecStart = "${displaylink}/bin/DisplayLinkManager";
        Restart = "always";
        RestartSec = 5;
      };

      preStart = ''
        mkdir -p /var/log/displaylink
        modprobe evdi
      '';
    };

  };

}
