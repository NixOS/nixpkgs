{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hdapsd;
  hdapsd = [ pkgs.hdapsd ];
in
{
  options = {
    services.hdapsd.enable = mkEnableOption
      (lib.mdDoc ''
        Hard Drive Active Protection System Daemon,
        devices are detected and managed automatically by udev and systemd
      '');
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "hdapsd" ];
    services.udev.packages = hdapsd;
    systemd.packages = hdapsd;
  };
}
