{ pkgs, lib, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.pipewire;
  testConfig = {
    hardware.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };
  };
}
