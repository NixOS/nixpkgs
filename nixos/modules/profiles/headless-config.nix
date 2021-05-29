# Common configuration for headless machines (e.g., Amazon EC2
# instances).

{ config, lib, ... }:

let
  cfg = config.profiles.headless;
in
{
  options.profiles.headless = {
    enable = lib.mkEnableOption "the headless profile";

    serial.enable = lib.mkEnableOption "starting a tty on the serial consoles";
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      boot.vesa = false;

      # Since we can't manually respond to a panic, just reboot.
      boot.kernelParams = [ "panic=1" "boot.panic_on_fail" ];

      # Don't allow emergency mode, because we don't have a console.
      systemd.enableEmergencyMode = false;

      # Being headless, we don't need a GRUB splash image.
      boot.loader.grub.splashImage = null;
    }

    (lib.mkIf (!cfg.serial.enable) {
      systemd.services."serial-getty@ttyS0".enable = false;
      systemd.services."serial-getty@hvc0".enable = false;
      systemd.services."getty@tty1".enable = false;
      systemd.services."autovt@".enable = false;
    })
  ]);
}
