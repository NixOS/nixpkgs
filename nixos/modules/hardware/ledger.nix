{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.ledger;

in {
  options.hardware.ledger.enable = mkEnableOption "udev rules for Ledger devices";

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.ledger-udev-rules ];
  };
}
