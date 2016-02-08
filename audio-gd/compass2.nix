{ config, pkgs, ... }:

{
  boot = {
    extraModprobeConfig = ''
      options snd slots=snd_usb_audio,snd-hda-intel
    '';
  };
}
