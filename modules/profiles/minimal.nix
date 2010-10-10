# This module defines a small NixOS configuration.  It does not
# contain any graphical stuff.

{config, pkgs, ...}:

{
  require = [ ./base.nix ];

  # Don't include X libraries.
  services.openssh.forwardX11 = false;
  services.dbus.enable = false; # depends on libX11
  services.hal.enable = false; # depends on dbus
  fonts.enableFontConfig = false;
  fonts.enableCoreFonts = false;
}
