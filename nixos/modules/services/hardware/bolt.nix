# Thunderbolt 3 device manager

{ config, lib, pkgs, ...}:

with lib;

{
  options = {

    services.hardware.bolt = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable Bolt, a userspace daemon to enable
          security levels for Thunderbolt 3 on GNU/Linux.

          Bolt is used by GNOME 3 to handle Thunderbolt settings.
        '';
      };

    };

  };

  config = mkIf config.services.hardware.bolt.enable {

    environment.systemPackages = [ pkgs.bolt ];
    services.udev.packages = [ pkgs.bolt ];
    systemd.packages = [ pkgs.bolt ];

  };
}
