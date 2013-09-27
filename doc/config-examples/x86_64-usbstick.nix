# Configuration file used to install NixOS-x86_64 on a USB stick.

{
  boot = {
    loader.grub.device = "/dev/sda";
    initrd = {
      kernelModules = ["usb_storage" "ehci_hcd" "ohci_hcd"];
    };
  };

  fileSystems = [
    { mountPoint = "/";
      label = "nixos-usb";
    }
  ];

  fonts = {
    enableFontConfig = false;
  };
}
