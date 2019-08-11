{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hardware.steam-hardware;

in

{
  options.hardware.steam-hardware = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable udev rules for Steam hardware such as the Steam Controller, other supported controllers and the HTC Vive";
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [
      pkgs.steamPackages.steam
    ];
  };
}
