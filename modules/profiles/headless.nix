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

  # Since we don't have an (interactive) console, disable the
  # emergency shell (started if mountall fails).
  jobs."mount-failed".script = mkOverride 50
    ''
      ${pkgs.utillinux}/bin/logger -p user.emerg -t mountall "filesystem ‘$DEVICE’ could not be mounted on ‘$MOUNTPOINT’"
    '';

  # Likewise, redirect mountall output from the console to the default
  # Upstart job log file.
  jobs."mountall".console = mkOverride 50 "";
}
