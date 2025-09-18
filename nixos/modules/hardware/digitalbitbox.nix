{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hardware.digitalbitbox;
in

{
  options.hardware.digitalbitbox = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        **DEPRECATED**: Enable udev rules for DigitalBitBox devices.
        DigitalBitBox has been EOL since 2019.
        Use `hardware.bitbox02.enable` for BitBox02 devices instead.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = [
      "hardware.digitalbitbox is deprecated. DigitalBitBox is EOL since 2019. Consider using hardware.bitbox02 instead."
    ];

    services.udev.packages = [ pkgs.bitbox ];
  };
}
