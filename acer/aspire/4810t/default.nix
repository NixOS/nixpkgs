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
    enable = true;
    defaultDepth = 24;
    videoDriver = "intel";
    autorun = true;
    synaptics = {
      enable = true;
      dev = "/dev/input/event8";
    };
  };
}
