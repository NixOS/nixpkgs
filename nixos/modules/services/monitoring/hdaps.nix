{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hdapsd;
  hdapsd = [ pkgs.hdapsd ];
in
{
  options = {
    services.hdapsd.enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Whether to enable Hard Drive Active Protection System Daemon.
        Devices are detected and managed automatically by udev and systemd.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = hdapsd;
    systemd.packages = hdapsd;
  };
}
