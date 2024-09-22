# This module defines a small NixOS configuration.  It does not
# contain any graphical stuff.

{ config, lib, ... }:

with lib;

{
  documentation.enable = mkDefault false;

  documentation.doc.enable = mkDefault false;

  documentation.info.enable = mkDefault false;

  documentation.man.enable = mkDefault false;

  documentation.nixos.enable = mkDefault false;

  # Perl is a default package.
  environment.defaultPackages = mkDefault [ ];

  environment.stub-ld.enable = mkDefault false;

  # The lessopen package pulls in Perl.
  programs.less.lessopen = mkDefault null;

  # This pulls in nixos-containers which depends on Perl.
  boot.enableContainers = mkDefault false;

  programs.command-not-found.enable = mkDefault false;

  programs.ssh.setXAuthLocation = mkDefault false;

  services.logrotate.enable = mkDefault false;

  services.udisks2.enable = mkDefault false;

  xdg.autostart.enable = mkDefault false;
  xdg.icons.enable = mkDefault false;
  xdg.mime.enable = mkDefault false;
  xdg.sounds.enable = mkDefault false;
}
