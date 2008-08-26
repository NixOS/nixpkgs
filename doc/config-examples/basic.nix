{
  boot = {
    grubDevice = "/dev/sda";
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
    sshd = {
      enable = true;
    };
  };
}
