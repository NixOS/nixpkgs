{pkgs, config, ...}:

{
  services = {
    udev = {
      # Warning: setting this option requires acceptance of the firmware
      # license, see http://ipw2200.sourceforge.net/firmware.php?fid=7.
      addFirmware = [ pkgs.ipw2200fw ];
    };
  };
}