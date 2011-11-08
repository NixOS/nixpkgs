# This module defines a small NixOS configuration.  It does not
# contain any graphical stuff.

{ config, pkgs, ... }:

{
  # Don't include X libraries.
  services.openssh.forwardX11 = false;
  fonts.enableFontConfig = false;
  fonts.enableCoreFonts = false;
}
