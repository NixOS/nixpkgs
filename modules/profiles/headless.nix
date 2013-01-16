# Common configuration for headless machines (e.g., Amazon EC2
# instances).

{ config, pkgs, ... }:

with pkgs.lib;

{
  sound.enable = false;
  boot.vesa = false;
  boot.initrd.enableSplashScreen = false;
  services.ttyBackgrounds.enable = false;

  # Don't start a tty on the serial consoles.
  systemd.services."serial-getty@ttyS0".enable = false;
  systemd.services."serial-getty@hvc0".enable = false;

  # Since we can't manually respond to a panic, just reboot.
  boot.kernelParams = [ "panic=1" "boot.panic_on_fail" ];
}
