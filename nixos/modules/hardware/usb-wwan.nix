{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface

  options = {

    hardware.usbWwan = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable this option to support USB WWAN adapters.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf config.hardware.usbWwan.enable {
    # Attaches device specific handlers.
    services.udev.packages = with pkgs; [ usb-modeswitch-data ];

    # Triggered by udev, usb-modeswitch creates systemd services via a
    # template unit in the usb-modeswitch package.
    systemd.packages = with pkgs; [ usb-modeswitch ];

    # The systemd service requires the usb-modeswitch-data. The
    # usb-modeswitch package intends to discover this via the
    # filesystem at /usr/share/usb_modeswitch, and merge it with user
    # configuration in /etc/usb_modeswitch.d. Configuring the correct
    # path in the package is difficult, as it would cause a cyclic
    # dependency.
    environment.etc."usb_modeswitch.d".source = "${pkgs.usb-modeswitch-data}/share/usb_modeswitch";
  };
}
