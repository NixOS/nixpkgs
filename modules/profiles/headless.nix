# Common configuration for headless machines (e.g., Amazon EC2
# instances).

{ config, pkgs, ... }:

with pkgs.lib;

{
  sound.enable = false;
  boot.vesa = false;
  boot.initrd.enableSplashScreen = false;
  services.ttyBackgrounds.enable = false;
  services.mingetty.ttys = [ ];

  # Since we can't manually respond to a panic, just reboot.
  boot.kernelParams = [ "panic=1" "stage1panic=1" ];
}
