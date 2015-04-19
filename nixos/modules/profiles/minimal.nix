# This module defines a small NixOS configuration.  It does not
# contain any graphical stuff.

{ config, lib, pkgs, ... }:

with lib;

{
  environment.noXlibs = mkDefault true;
  i18n.supportedLocales = [ config.i18n.defaultLocale ];
}
