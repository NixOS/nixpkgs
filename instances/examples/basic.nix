{
  boot = {
    autoDetectRootDevice = false;
    readOnlyRoot = false;
    grubDevice = "/dev/hda";
  };

  fileSystems = [
    { mountPoint = "/";
      device = "/dev/hda1";
    }
  ];

  swapDevices = ["/dev/hdb1"];
  
  services = {
    sshd = {
      enable = true;
    };
  };
}
