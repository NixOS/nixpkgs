{ config, lib, pkgs, ... }:

{
  boot = {
    # wireless
    kernelModules = [ "kvm-amd" "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

    # audio device
    extraModprobeConfig = ''
      options snd_hda_intel enable=0,1
    '';
  };

  # video card
  services.xserver.videoDrivers = ["ati"];

  # trackpad (touchpad disabled)
  hardware.trackpoint = {
    enable = true;
    emulateWheel = true;
  };

  # media keys
  sound.enableMediaKeys = true;
}
