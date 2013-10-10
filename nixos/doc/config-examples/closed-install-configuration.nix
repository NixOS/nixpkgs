{
  boot = {
    loader.grub.device = "/dev/sda";
    copyKernels = true;
    bootMount = "(hd0,0)";
  };

  fileSystems = [
    { mountPoint = "/";
      device = "/dev/sda3";
    }
    { mountPoint = "/boot";
      device = "/dev/sda1";
      neededForBoot = true;
    }
  ];

  swapDevices = [
    { device = "/dev/sda2"; }
  ];

  services = {
    sshd = {
      enable = true;
    };
  };

  fonts = {
    enableFontConfig = false;
  };

}
