{ config, lib, pkgs, ...}:
let
  cfg = config.services.hardware.bolt;
in
{
  options = {
    services.hardware.bolt = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable Bolt, a userspace daemon to enable
          security levels for Thunderbolt 3 on GNU/Linux.

          Bolt is used by GNOME 3 to handle Thunderbolt settings.
        '';
      };

      package = lib.mkPackageOption pkgs "bolt" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
  };
}
