# Configuration file used to install NixOS-x86_64 on a USB stick.

{
  boot = {
    grubDevice = "/dev/sda";
    initrd = {
      kernelModules = ["usb_storage" "ehci_hcd" "ohci_hcd"];
      enableSplashScreen = false;
    };
  };

  fileSystems = [
    { mountPoint = "/";
      label = "nixos-usb";
    }
  ];

  services = {
    ttyBackgrounds = {
      enable = false;
    };
  };

  fonts = {
    enableFontConfig = false;
  };
}
