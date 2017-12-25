{
  boot = {
    extraModprobeConfig = lib.mkDefault ''
      options snd slots=snd_usb_audio,snd-hda-intel
    '';
  };
}
