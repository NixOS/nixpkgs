{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.keyboard.teck;
  inherit (lib) mdDoc mkEnableOption mkIf;

in
{
  options.hardware.keyboard.teck = {
    enable = mkEnableOption (mdDoc "non-root access to the firmware of TECK keyboards");
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.teck-udev-rules ];
  };
}
