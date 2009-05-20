{pkgs, config, ...}:

{
  services = {
    udev = {
      addFirmware = [ pkgs.zd1211fw ];
    };
  };
}
