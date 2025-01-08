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
    enable = lib.mkDefault false;
    doc.enable = lib.mkDefault false;
    info.enable = lib.mkDefault false;
    man.enable = lib.mkDefault false;
    nixos.enable = lib.mkDefault false;
  };

  environment = {
    # Perl is a default package.
    defaultPackages = lib.mkDefault [ ];
    stub-ld.enable = lib.mkDefault false;
  };

  programs = {
    # The lessopen package pulls in Perl.
    less.lessopen = lib.mkDefault null;
    command-not-found.enable = lib.mkDefault false;
  };

  # This pulls in nixos-containers which depends on Perl.
  boot.enableContainers = lib.mkDefault false;

  services = {
    logrotate.enable = lib.mkDefault false;
    udisks2.enable = lib.mkDefault false;
  };

  xdg = {
    autostart.enable = lib.mkDefault false;
    icons.enable = lib.mkDefault false;
    mime.enable = lib.mkDefault false;
    sounds.enable = lib.mkDefault false;
  };
}
