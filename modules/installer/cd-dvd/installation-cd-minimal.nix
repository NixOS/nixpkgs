# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.

{config, pkgs, ...}:

{
  require = [./installation-cd-base.nix];

  installer.configModule = "./nixos/modules/installer/cd-dvd/installation-cd-minimal.nix";

  # allow starting sshd by running "start sshd"
  services.sshd.enable = true;
  jobs.sshd.startOn = "never-start-ssh-automatically-you-should-set-root-password-first";

  # Don't include X libraries.
  services.sshd.forwardX11 = false;
  services.dbus.enable = false; # depends on libX11
  services.hal.enable = false; # depends on dbus
  fonts.enableFontConfig = false;
  fonts.enableCoreFonts = false;
}
