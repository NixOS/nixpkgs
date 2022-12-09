# This module defines a small NixOS configuration.  It does not
# contain any graphical stuff.

{ config, lib, ... }:

{
  documentation.enable = lib.mkDefault false;

  documentation.doc.enable = lib.mkDefault false;

  documentation.info.enable = lib.mkDefault false;

  documentation.man.enable = lib.mkDefault false;

  documentation.nixos.enable = lib.mkDefault false;

  programs.command-not-found.enable = lib.mkDefault false;

  services.logrotate.enable = lib.mkDefault false;

  services.udisks2.enable = lib.mkDefault false;

  xdg.autostart.enable = lib.mkDefault false;
  xdg.icons.enable = lib.mkDefault false;
  xdg.mime.enable = lib.mkDefault false;
  xdg.sounds.enable = lib.mkDefault false;
}
