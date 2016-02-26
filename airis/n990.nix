{ ... }:

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

  services.xserver = {
    videoDriver = "unichrome";
    synaptics.enable = true;
  };

  networking.enableIntel2200BGFirmware = true;
}
