{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.ddccontrol;
in

{
  ###### interface

  options = {
    services.ddccontrol = {
      enable = lib.mkEnableOption ''
        ddccontrol for controlling displays.

        This [enables `hardware.i2c`](#opt-hardware.i2c.enable), so note to add
        yourself to [`hardware.i2c.group`](#opt-hardware.i2c.group).
      '';
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    # Load the i2c-dev module
    boot.kernelModules = [
      "ddcci_backlight"
    ];
    hardware.i2c = {
      enable = true;
    };

    # Give users access to the "gddccontrol" tool
    environment.systemPackages = [
      pkgs.ddccontrol
    ];

    services.dbus.packages = [
      pkgs.ddccontrol
    ];

    systemd.packages = [
      pkgs.ddccontrol
    ];
  };
}
