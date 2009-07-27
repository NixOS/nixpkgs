{pkgs, config, ...}:

{
  services = {
    udev = {
      addFirmware = [ pkgs.iwlwifi5000ucode ];
    };
  };
}
