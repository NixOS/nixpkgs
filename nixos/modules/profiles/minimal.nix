# This module defines a small NixOS configuration.  It does not
# contain any graphical stuff.

{ config, lib, pkgs, ... }:

{
  environment.noXlibs = true;
}
