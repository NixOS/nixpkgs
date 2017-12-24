{ lib, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
  ];

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
    defaultDepth = lib.mkDefault 24;
  };
}
