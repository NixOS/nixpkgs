{ config, lib, pkgs, ... }:
let

  cfg = config.hardware.nitrokey;

in

{
  options.hardware.nitrokey = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enables udev rules for Nitrokey devices. By default grants access
        to users in the "nitrokey" group. You may want to install the
        nitrokey-app package, depending on your device and needs.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ pkgs.libnitrokey ];
  };
}
