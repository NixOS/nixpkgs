# Udisks daemon.

{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    services.udisks2 = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable Udisks, a DBus service that allows
          applications to query and manipulate storage devices.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.udisks2.enable {

    environment.systemPackages = [ pkgs.udisks2 ];

    security.polkit.enable = true;

    services.dbus.packages = [ pkgs.udisks2 ];

    systemd.tmpfiles.rules = [ "d /var/lib/udisks2 0755 root root -" ];

    services.udev.packages = [ pkgs.udisks2 ];

    systemd.packages = [ pkgs.udisks2 ];
  };

}
