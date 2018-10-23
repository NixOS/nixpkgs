{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hardware.ledger-nano-s;

in

{
  options.hardware.ledger-nano-s = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enables udev rules for Ledger Nano S devices (https://www.ledger.com/products/ledger-nano-s).
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = lib.singleton (pkgs.writeTextFile {
      name = "ledger-nano-s-udev-rules";
      destination = "/etc/udev/rules.d/51-ledger-nano-s.rules";
      text = ''
        SUBSYSTEMS=="usb", ATTRS{manufacturer}=="Ledger", ATTRS{product}=="Nano S", ENV{ID_SECURITY_TOKEN}="1"
      '';
    });
  };

}
