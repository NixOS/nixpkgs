{ pkgs, lib, makeInstalledTest, ... }:

makeInstalledTest {
  tested = pkgs.pipewire;
  excludeTestRegex = "alsa-stress";
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
