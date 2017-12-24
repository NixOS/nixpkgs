{ lib, ... }:

{
  boot = {
    initrd.kernelModules = [ "ata_piix" ];
    kernelParams = [
      "apm=on"
      "acpi=on"
      "vga=0x317"
      "video=vesafb:ywrap"
      # Important, to disable Kernel Mode Setting for the graphics card
      # This will allow backlight regulation
      "nomodeset"
    ];
  };

  hardware.opengl.driSupport = false;

  services.xserver = {
    enable = lib.mkDefault true;
    defaultDepth = lib.mkDefault 24;
    videoDrivers = [ "intel" ];
    autorun = lib.mkDefault true;
    synaptics = {
      enable = lib.mkDefault true;
      dev = "/dev/input/event8";
    };
  };
}
