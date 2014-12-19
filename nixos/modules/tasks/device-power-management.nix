{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.powerManagement.enable {
    systemd.services."device-pm" = {
      description = "Enable automatic device power management";
      requires = [ "systemd-udev-trigger.service" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        shopt -s nullglob
        for x in /sys/bus/{pci,usb}/devices/*/power/control ; do echo -n auto >$x ; done
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
      };
    };
  };
}
