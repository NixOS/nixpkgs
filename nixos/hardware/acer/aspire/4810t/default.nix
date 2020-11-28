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

      # Important, disable KMS to fix backlight regulation:
      "nomodeset"
    ];
  };

  # TODO: reverse compat
  hardware.opengl.driSupport = false;

  # TODO: reverse compat
  services.xserver = {
    defaultDepth = lib.mkDefault 24;
  };
}
