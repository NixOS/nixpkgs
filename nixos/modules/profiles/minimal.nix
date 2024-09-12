# This module defines a small NixOS configuration.  It does not
# contain any graphical stuff.

{ config, lib, ... }:
{
  environment.noXlibs = lib.mkDefault true;

  documentation.enable = lib.mkDefault false;

  documentation.doc.enable = lib.mkDefault false;

  documentation.info.enable = lib.mkDefault false;

  documentation.man.enable = lib.mkDefault false;

  documentation.nixos.enable = lib.mkDefault false;

  # Perl is a default package.
  environment.defaultPackages = lib.mkDefault [ ];

  environment.stub-ld.enable = false;

  # The lessopen package pulls in Perl.
  programs.less.lessopen = lib.mkDefault null;

  # This pulls in nixos-containers which depends on Perl.
  boot.enableContainers = lib.mkDefault false;

  programs.command-not-found.enable = lib.mkDefault false;

  services.logrotate.enable = lib.mkDefault false;

  services.udisks2.enable = lib.mkDefault false;

  xdg.autostart.enable = lib.mkDefault false;
  xdg.icons.enable = lib.mkDefault false;
  xdg.mime.enable = lib.mkDefault false;
  xdg.sounds.enable = lib.mkDefault false;
}
