{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.trezord;
in {
  
  ### interface

  options = {
    services.trezord = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable Trezor bridge daemon, for use with Trezor hardware bitcoin wallets.
        '';
      };
    };
  };
  
  ### implementation

  config = mkIf cfg.enable {
    services.udev.packages = lib.singleton (pkgs.writeTextFile {
      name = "trezord-udev-rules";
      destination = "/etc/udev/rules.d/51-trezor.rules";
      text = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE="0666", GROUP="dialout", SYMLINK+="trezor%n"
        KERNEL=="hidraw*", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001",  MODE="0666", GROUP="dialout"
      '';
    });

    systemd.services.trezord = {
      description = "TREZOR Bridge";
      after = [ "systemd-udev-settle.service" "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.trezord}/bin/trezord-go";
        User = "trezord";
      };
    };

    users.users.trezord = {
      group = "trezord";
      description = "Trezor bridge daemon user";
    };

    users.groups.trezord = {};
  };
}

