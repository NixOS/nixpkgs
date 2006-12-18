{
  boot = {
    autoDetectRootDevice = false;
    rootDevice = "/dev/hda1";
    readOnlyRoot = false;
    grubDevice = "/dev/hda";
  };
  services = {
    sshd = {
      enable = true;
    };
  };
}
