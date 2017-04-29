{ config, lib, pkgs, ... }:

with lib;

let
  bluez-bluetooth = pkgs.bluez;
  cfg = config.hardware.bluetooth;

in {

  ###### interface

  options = {

    hardware.bluetooth = {
      enable = mkEnableOption "support for Bluetooth.";

      powerOnBoot = mkOption {
        type    = types.bool;
        default = true;
        description = "Whether to power up the default Bluetooth controller on boot.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          [General]
          ControllerMode = bredr
        '';
        description = ''
          Set additional configuration for system-wide bluetooth (/etc/bluetooth/main.conf).

          NOTE: We already include [Policy], so any configuration under the Policy group should come first.
        '';
      };
    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ bluez-bluetooth pkgs.openobex pkgs.obexftp ];

    environment.etc = singleton {
      source = pkgs.writeText "main.conf" ''
        [Policy]
        AutoEnable=${lib.boolToString cfg.powerOnBoot}

        ${cfg.extraConfig}
      '';
      target = "bluetooth/main.conf";
    };

    services.udev.packages = [ bluez-bluetooth ];
    services.dbus.packages = [ bluez-bluetooth ];
    systemd.packages       = [ bluez-bluetooth ];

    systemd.services = {
      bluetooth = {
        wantedBy = [ "bluetooth.target" ];
        aliases  = [ "dbus-org.bluez.service" ];
      };
    };

    systemd.user.services = {
      obex.aliases = [ "dbus-org.bluez.obex.service" ];
    };

  };

}
