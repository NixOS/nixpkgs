{ config, lib, ... }:

let
  cfg = config.hardware.katana-usb-audio;
  katana-usb-audio = config.boot.kernelPackages.katana-usb-audio;
in
{
  options.hardware.katana-usb-audio = {
    enable = lib.mkEnableOption "Enables the kernel module an udev rules for the Creative Katana Soundblaster";
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "katana-usb-audio" ];
    boot.extraModulePackages = [ katana-usb-audio ];
    services.udev.packages = [ katana-usb-audio ];
  };

  meta.maintainers = [ lib.maintainers.Svenum ];
}
