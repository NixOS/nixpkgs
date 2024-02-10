{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.keyboard.qmk;
  inherit (lib) mdDoc mkEnableOption mkIf;

in
{
  options.hardware.keyboard.qmk = {
    enable = mkEnableOption (mdDoc "non-root access to the firmware of QMK keyboards");
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.qmk-udev-rules ];
    users.groups.plugdev = {};
  };
}
