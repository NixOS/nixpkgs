{ config, lib, pkgs, ... }:

with lib; {
  options.hardware.uhk.enable = mkEnableOption
    "Enable support for UHK (Ultimate Hacking Keyboard) keyboards";

  config = mkIf config.hardware.uhk.enable {
    environment.systemPackages = [ pkgs.uhk-agent ];
    services.udev.packages = [ pkgs.uhk-udev-rules ];
  };
}
