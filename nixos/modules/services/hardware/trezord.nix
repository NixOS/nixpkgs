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
        # TREZOR v1 (One)
        SUBSYSTEM=="usb", ATTR{idVendor}=="534c", ATTR{idProduct}=="0001", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="trezor%n"
        KERNEL=="hidraw*", ATTRS{idVendor}=="534c", ATTRS{idProduct}=="0001",  MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"
        # TREZOR v2 (T)
        SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="53c0", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="trezor%n"
        SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="53c1", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="trezor%n"
        KERNEL=="hidraw*", ATTRS{idVendor}=="1209", ATTRS{idProduct}=="53c1", MODE="0660", GROUP="plugdev", TAG+="uaccess", TAG+="udev-acl"
  ];
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

