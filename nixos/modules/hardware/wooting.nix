{ config, lib, pkgs, ... }:

with lib;
{
  options.hardware.wooting.enable =
    mkEnableOption "Enable support for Wooting keyboards";

  config = mkIf config.hardware.wooting.enable {
    environment.systemPackages = [ pkgs.wootility ];
    services.udev.packages = [ pkgs.wooting-udev-rules ];
  };
}
