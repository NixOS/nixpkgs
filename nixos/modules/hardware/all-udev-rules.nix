{ config, lib, pkgs, ... }:

with lib;

let
  android-udev-rules = pkgs.callPackage ./udev-rules/android.nix {};
  ledger-udev-rules = pkgs.callPackage ./udev-rules/ledger.nix {};
  logitech-udev-rules = pkgs.callPackage ./udev-rules/logitech.nix {};
  nitrokey-udev-rules = pkgs.callPackage ./udev-rules/nitrokey.nix {};

in {

  ###### interface

  options = {

    hardware.enableAllUdevRules = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Turn on this option if you want to enable all the udev rules we have.
      '';
    };

  };


  ###### implementation

  config = mkIf config.hardware.enableAllUdevRules {
    services.udev.extraRules = ''
      # digitalbitbox
      SUBSYSTEM=="usb", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="dbb%n", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402"
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", TAG+="uaccess", TAG+="udev-acl", SYMLINK+="dbbf%n"

      # onlykey
      ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", ENV{ID_MM_DEVICE_IGNORE}="1"
      ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", ENV{MTP_NO_PROBE}="1"
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", MODE:="0666"
      KERNEL=="ttyACM*", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="60fc", MODE:="0666"
    '';

    services.udev.packages = [
      android-udev-rules
      ledger-udev-rules
      logitech-udev-rules
      nitrokey-udev-rules
      pkgs.usb-modeswitch-data
    ];
  };
}
