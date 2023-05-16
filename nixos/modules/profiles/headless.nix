# Common configuration for headless machines (e.g., Amazon EC2
# instances).

{ lib, ... }:

with lib;

{
<<<<<<< HEAD
=======
  boot.vesa = false;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # Don't start a tty on the serial consoles.
  systemd.services."serial-getty@ttyS0".enable = lib.mkDefault false;
  systemd.services."serial-getty@hvc0".enable = false;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@".enable = false;

  # Since we can't manually respond to a panic, just reboot.
<<<<<<< HEAD
  boot.kernelParams = [ "panic=1" "boot.panic_on_fail" "vga=0x317" "nomodeset" ];
=======
  boot.kernelParams = [ "panic=1" "boot.panic_on_fail" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Don't allow emergency mode, because we don't have a console.
  systemd.enableEmergencyMode = false;

  # Being headless, we don't need a GRUB splash image.
  boot.loader.grub.splashImage = null;
}
