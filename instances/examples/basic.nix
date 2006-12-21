{
  boot = {
    autoDetectRootDevice = false;
    readOnlyRoot = false;
    grubDevice = "/dev/hda";
  };

  filesystems = [
    { mountPoint = "/";
      device = "/dev/hda1";
    }
  ];
  
  services = {
    sshd = {
      enable = true;
    };
  };
}
