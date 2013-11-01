{
  boot = {
    loader.grub.device = "/dev/sda";
  };

  fileSystems = [
    { mountPoint = "/";
      device = "/dev/sda1";
    }
  ];

  swapDevices = [
    { device = "/dev/sdb1"; }
  ];

  services = {
    openssh = {
      enable = true;
    };
  };
}
