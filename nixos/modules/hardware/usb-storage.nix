{ config, lib, pkgs, ... }:
with lib;

{
  options.hardware.usbStorage.manageStartStop = mkOption {
    type = types.bool;
    default = true;
    description = lib.mdDoc ''
      Enable this option to gracefully spin-down external storage during shutdown.
      If you suspect improper head parking after poweroff, install `smartmontools` and check
      for the `Power-Off_Retract_Count` field for an increment.
    '';
  };

  config = mkIf config.hardware.usbStorage.manageStartStop {
    services.udev.extraRules = ''
      ACTION=="add|change", SUBSYSTEM=="scsi_disk", DRIVERS=="usb-storage", ATTR{manage_start_stop}="1"
    '';
  };
}
