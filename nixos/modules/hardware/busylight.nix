{ config, lib, pkgs, ... }:

with lib;

let cfg = config.hardware.busylight;

in

{
  options.hardware.busylight = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enables udev rules for busylight-compatible devices.  By
        default grants access to all users.  You may want to install
        the busylight package.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.python3Packages.busylight ];
  };
}
