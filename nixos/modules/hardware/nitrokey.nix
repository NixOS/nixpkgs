{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hardware.nitrokey;

in

{
  options.hardware.nitrokey = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables udev rules for Nitrokey devices. By default grants access
        to users in the "nitrokey" group. You may want to install the
        nitrokey-app package, depending on your device and needs.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.libnitrokey ];
  };
}
