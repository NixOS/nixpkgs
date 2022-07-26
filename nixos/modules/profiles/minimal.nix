# This module defines a small NixOS configuration.  It does not
# contain any graphical stuff.

{ config, lib, ... }:

with lib;

{
  environment.noXlibs = mkDefault true;

  documentation.enable = mkDefault false;

  documentation.nixos.enable = mkDefault false;

  programs.command-not-found.enable = mkDefault false;
}
