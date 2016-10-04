# This module defines a small NixOS configuration.  It does not
# contain any graphical stuff.

{ config, lib, pkgs, ... }:

with lib;

{
  environment.noXlibs = mkDefault true;

  # This isn't perfect, but let's expect the user specifies an UTF-8 defaultLocale
  i18n.supportedLocales = [ (config.i18n.defaultLocale + "/UTF-8") ];
  services.nixosManual.enable = mkDefault false;

  programs.man.enable = mkDefault false;
  programs.info.enable = mkDefault false;
}
