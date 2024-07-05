{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.keyboard.qmk;
  inherit (lib) mkEnableOption mkIf;

in
{
  options.hardware.keyboard.qmk = {
    enable = mkEnableOption "non-root access to the firmware of QMK keyboards";
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.qmk-udev-rules ];
    users.groups.plugdev = {};
  };
}
