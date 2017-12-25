{ config, lib, ... }:

{
  imports = [ ../. ];

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ mba6x_bl ];
    kernelModules = [ "mba6x_bl" ];
  };

  services.xserver.deviceSection = lib.mkDefault ''
    Option "Backlight" "mba6x_backlight"
  '';
}
