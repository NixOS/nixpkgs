{ config, lib, pkgs, ... }:

with lib; {
  options.hardware.rasdaemon.enable = mkEnableOption "RAS logging daemon";

  config = mkIf config.hardware.rasdaemon.enable {
    systemd = {
      packages = [ pkgs.rasdaemon ];
      services.rasdaemon.enable = true;
      services.ras-mc-ctl.enable = true;
    };
  };
}
