{ config, lib, ... }:

with lib;

let

  enabled = elem "displaylink" config.services.xserver.videoDrivers;

  displaylink = config.boot.kernelPackages.displaylink;

in

{

  config = mkIf enabled {

    boot.extraModulePackages = [ displaylink ];

    boot.kernelModules = [ "evdi" ];

    # Those are taken from displaylink-installer.sh and from Arch Linux AUR package.

    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="17e9", ATTR{bNumInterfaces}=="*5", TAG+="uaccess"
    '';

    powerManagement.powerDownCommands = ''
      #flush any bytes in pipe
      while read -n 1 -t 1 SUSPEND_RESULT < /tmp/PmMessagesPort_out; do : ; done;

      #suspend DisplayLinkManager
      echo "S" > /tmp/PmMessagesPort_in

      #wait until suspend of DisplayLinkManager finish
      read -n 1 -t 10 SUSPEND_RESULT < /tmp/PmMessagesPort_out
    '';

    powerManagement.resumeCommands = ''
      #resume DisplayLinkManager
      echo "R" > /tmp/PmMessagesPort_in
    '';

    systemd.services.displaylink = {
      description = "DisplayLink Manager Service";
      after = [ "display-manager.service" ];
      wantedBy = [ "graphical.target" ];

      serviceConfig = {
        ExecStart = "${displaylink}/bin/DisplayLinkManager";
        Restart = "always";
        RestartSec = 5;
      };

      preStart = ''
        mkdir -p /var/log/displaylink
      '';
    };

  };

}
