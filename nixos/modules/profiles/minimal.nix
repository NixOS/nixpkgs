# This module defines a small NixOS configuration.  It does not
# contain any graphical stuff.

{ config, lib, ... }:

with lib;

{
  environment.noXlibs = mkDefault true;

  documentation.enable = mkDefault false;

  documentation.doc.enable = mkDefault false;

  documentation.info.enable = mkDefault false;

  documentation.man.enable = mkDefault false;

  documentation.nixos.enable = mkDefault false;

  programs.command-not-found.enable = mkDefault false;

  services.logrotate.enable = mkDefault false;

  services.udisks2.enable = mkDefault false;

  xdg.autostart.enable = mkDefault false;
  xdg.icons.enable = mkDefault false;
  xdg.mime.enable = mkDefault false;
  xdg.sounds.enable = mkDefault false;
}
