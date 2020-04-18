{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.u2f;
in {
  options = {
    hardware.u2f = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable U2F hardware support.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.libu2f-host ];
  };
}

