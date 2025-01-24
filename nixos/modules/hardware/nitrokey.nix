{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.hardware.nitrokey;

in

{
  options.hardware.nitrokey = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enables udev rules for Nitrokey devices.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [ pkgs.nitrokey-udev-rules ];
  };
}
