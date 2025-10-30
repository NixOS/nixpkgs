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
  meta.maintainers = with lib.maintainers; [ doronbehar ];

  ###### interface

  options = {
    services.ddccontrol = {
      enable = lib.mkEnableOption ''
        ddccontrol for controlling displays.

        This [enables `hardware.i2c`](#opt-hardware.i2c.enable), so note to add
        yourself to [`hardware.i2c.group`](#opt-hardware.i2c.group).
      '';
      package = lib.mkPackageOption pkgs "package with which to control brightness" {
        default = [ "ddccontrol" ];
        example = [ "ddcui" ];
      };
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
      cfg.package
    ];

    services.dbus.packages = [
      cfg.package
    ];

    systemd.packages = [
      cfg.package
    ];
  };
}
