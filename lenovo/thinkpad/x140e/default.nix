{ config, lib, pkgs, ... }:

{
  imports = [ ../common.nix ];

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
  services.xserver.videoDrivers = [ "ati" ];
}
