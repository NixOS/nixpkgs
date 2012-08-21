# Upower daemon.

{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    services.upower = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable Upower, a DBus service that provides power
          management support to applications.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.upower.enable {

    environment.systemPackages = [ pkgs.upower ];

    services.dbus.packages = [ pkgs.upower ];

    services.udev.packages = [ pkgs.upower ];

    boot.systemd.packages = [ pkgs.upower ];

    system.activationScripts.upower =
      ''
        mkdir -m 0755 -p /var/lib/upower
      '';

  };

}
