{ config, lib, pkgs, ... }:

with lib;
{
  options.hardware.inputmodule.enable = mkEnableOption ''
    Enable support for Framework input modules
  '';

  config = mkIf config.hardware.inputmodule.enable {
    environment.systemPackages = [ pkgs.inputmodule-control ];
    services.udev.packages = [ pkgs.inputmodule-control ];
  };
}
