{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.tilp2;

in {
  options.programs.tilp2 = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable tilp2 and udev rules for supported calculators.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [
      pkgs.libticables2
    ];

    environment.systemPackages = [
      pkgs.tilp2
    ];
  };
}
