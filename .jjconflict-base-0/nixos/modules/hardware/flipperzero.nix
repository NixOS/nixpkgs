{ config, lib, pkgs, ... }:
let

  cfg = config.hardware.flipperzero;

in

{
  options.hardware.flipperzero.enable = lib.mkEnableOption "udev rules and software for Flipper Zero devices";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.qFlipper ];
    services.udev.packages = [ pkgs.qFlipper ];
  };
}
