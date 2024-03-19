{ config, lib, pkgs, ... }:

with lib;
{
  options.hardware.wooting.enable = mkEnableOption (lib.mdDoc ''support for Wooting keyboards.
    Note that users must be in the "input" group for udev rules to apply'');

  config = mkIf config.hardware.wooting.enable {
    environment.systemPackages = [ pkgs.wootility ];
    services.udev.packages = [ pkgs.wooting-udev-rules ];
  };
}
