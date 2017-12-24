{ lib, pkgs, ... }:

{
  boot = {
    initrd.kernelModules = [ "pata_via" ];

    kernelParams = [
      "apm=on"
      "acpi=on"
      "vga=0x317"  # 1024x768
      "console=tty1"
      "video=vesafb:ywrap"  # Faster scroll
     ];
  };

  hardware.firmware = with pkgs; [ intel2200BGFirmware ];

  services.xserver = {
    synaptics.enable = lib.mkDefault true;
    videoDrivers = [ "unichrome" ];
  };
}
