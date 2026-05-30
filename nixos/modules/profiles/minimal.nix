# This module defines a small NixOS configuration.  It does not
# contain any graphical stuff.

{
  lib,
  ...
}:
let
  inherit (lib) mkDefault;
in
{
  documentation = {
    enable = mkDefault false;
    doc.enable = mkDefault false;
    info.enable = mkDefault false;
    man.enable = mkDefault false;
    nixos.enable = mkDefault false;
  };

  environment = {
    # Perl is a default package.
    defaultPackages = mkDefault [ ];
    stub-ld.enable = mkDefault false;
  };

  programs = {
    command-not-found.enable = mkDefault false;
    fish.generateCompletions = mkDefault false;
  };

  services = {
    logrotate.enable = mkDefault false;
    udisks2.enable = mkDefault false;
  };

  xdg = {
    autostart.enable = mkDefault false;
    icons.enable = mkDefault false;
    mime.enable = mkDefault false;
    sounds.enable = mkDefault false;
  };
}
