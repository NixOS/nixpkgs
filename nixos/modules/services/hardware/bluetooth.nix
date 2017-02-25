{ config, lib, pkgs, ... }:

with lib;

let
  bluez-bluetooth = pkgs.bluez;
  cfg = config.hardware.bluetooth;

in

{

  ###### interface

  options = {

    hardware.bluetooth.enable = mkEnableOption "support for Bluetooth.";

    hardware.bluetooth.powerOnBoot = mkOption {
      type    = types.bool;
      default = true;
      description = "Whether to power up the default Bluetooth controller on boot.";
    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ bluez-bluetooth pkgs.openobex pkgs.obexftp ];

    services.udev.packages = [ bluez-bluetooth ];
    services.dbus.packages = [ bluez-bluetooth ];
    systemd.packages       = [ bluez-bluetooth ];

    services.udev.extraRules = optionalString cfg.powerOnBoot ''
      ACTION=="add", KERNEL=="hci[0-9]*", ENV{SYSTEMD_WANTS}="bluetooth-power@%k.service"
    '';

    systemd.services = {
      bluetooth = {
        wantedBy = [ "bluetooth.target" ];
        aliases  = [ "dbus-org.bluez.service" ];
      };

      "bluetooth-power@" = mkIf cfg.powerOnBoot {
        description = "Power up bluetooth controller";
        after = [
          "bluetooth.service"
          "suspend.target"
          "sys-subsystem-bluetooth-devices-%i.device"
        ];
        wantedBy = [ "suspend.target" ];

        serviceConfig.Type      = "oneshot";
        serviceConfig.ExecStart = "${pkgs.bluez.out}/bin/hciconfig %i up";
      };

    };

    systemd.user.services = {
      obex.aliases = [ "dbus-org.bluez.obex.service" ];
    };

  };

}
