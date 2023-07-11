{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.light;

in
{
  options = {
    programs.light = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether to install Light backlight control command
          and udev rules granting access to members of the "video" group.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.light ];
    services.udev.packages = [ pkgs.light ];
  };
}
