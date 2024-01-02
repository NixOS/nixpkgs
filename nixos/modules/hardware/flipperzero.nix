{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.hardware.flipperzero;

in

{
  options.hardware.flipperzero.enable = mkEnableOption (mdDoc "udev rules and software for Flipper Zero devices");

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.qFlipper ];
    services.udev.packages = [ pkgs.qFlipper ];
  };
}
