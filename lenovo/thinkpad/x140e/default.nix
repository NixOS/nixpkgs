{ config, lib, pkgs, ... }:

{
  imports = [ ../. ];

  boot = {
    # wireless
    kernelModules = [ "kvm-amd" "wl" ];
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

    # audio device
    extraModprobeConfig = lib.mkDefault ''
      options snd_hda_intel enable=0,1
    '';
  };

  # video card
  services.xserver.videoDrivers = [ "ati" ];
}
