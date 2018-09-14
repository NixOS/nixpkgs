{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.walabot;
in {
  options = {
    hardware.walabot = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable hardware support for a "Walabot Makers" device.

          This creates the statefull database needed by the `walabot-api` in
          `/var/lib/walabot/` and installs the necessary udev rule.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.walabot-hardware = {
      description = "Installs the Walabot SDK database";
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        if [ ! -d "/var/lib/walabot" ]; then
          mkdir -p /var/lib
          cp -r ${pkgs.walabot-sdk}/var/lib/walabot /var/lib/

          chmod 777 /var/lib/walabot/DB/
          chmod 666 /var/lib/walabot/DB/*
        fi
      '';
    };

    services.udev.packages = lib.singleton (pkgs.writeTextFile {
      name = "walabot-udev-rules";
      destination = "/etc/udev/rules.d/50-walabot.rules";
      text = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="2c9c", ATTR{idProduct}="1000", MODE="0666"
      '';
    });
  };
}
