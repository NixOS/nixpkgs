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
      package =
        lib.mkPackageOption pkgs
          "package with which to control brightness; added also to [services.dbus.packages](#opt-services.dbus.packages)."
          {
            default = [ "ddccontrol" ];
            example = [ "ddcutil-service" ];
          };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [
      "ddcci_backlight"
    ];
    boot.extraModulePackages = [
      config.boot.kernelPackages.ddcci-driver
    ];
    # Load the i2c-dev module
    hardware.i2c = {
      enable = true;
    };

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
