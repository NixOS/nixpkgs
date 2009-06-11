# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.

{config, pkgs, ...}:

{
  require = [./installation-cd-base.nix];

  # Don't include X libraries.
  services.sshd.forwardX11 = false;
  fonts.enableFontConfig = false;
  fonts.enableCoreFonts = false;
}
