# This module defines a small NixOS configuration.  It does not
# contain any graphical stuff.

{ config, lib, ... }:

with lib;

{
  environment.noXlibs = mkDefault true;

  # This isn't perfect, but let's expect the user specifies an UTF-8 defaultLocale
  i18n.supportedLocales = [ (config.i18n.defaultLocale + "/UTF-8") ];

  documentation.enable = mkDefault false;

  services.nixosManual.enable = mkDefault false;
}
