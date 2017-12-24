{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/amd
  ];

  boot.extraModprobeConfig = lib.mkDefault ''
    options snd_hda_intel enable=0,1
  '';

  services.xserver.videoDrivers = [ "ati" ];
}
