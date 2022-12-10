{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.hardware.keyboard.teck;
in
{
  options.hardware.keyboard.teck = {
    enable = mkEnableOption (lib.mdDoc "non-root access to the firmware of TECK keyboards");
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.teck-udev-rules ];
  };
}

