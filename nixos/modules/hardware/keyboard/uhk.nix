{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.keyboard.uhk;
in
{
  options.hardware.keyboard.uhk = {
    enable = mkEnableOption ''
    non-root access to the firmware of UHK keyboards.
      You need it when you want to flash a new firmware on the keyboard.
      Access to the keyboard is granted to users in the "input" group.
      You may want to install the uhk-agent package.
    '';

  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.uhk-udev-rules ];
  };
}
