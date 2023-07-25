{ config, lib, pkgs, ... }:

let cfg = config.hardware.busylight;

in

{
  options.hardware.busylight = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        Enables udev rules for busylight-compatible devices.  By
        default grants access to all users.  You may want to install
        the busylight package.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ pkgs.python3Packages.busylight ];
  };
}
