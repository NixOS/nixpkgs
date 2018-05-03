{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.ledger;
in {
  options = {
    hardware.ledger = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable Ledger hardware support.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.ledger-udev-rules ];
  };
}
