# This module defines a small netboot environment.

{ ... }:

{
  imports = [
    ./netboot-base.nix
    ../../profiles/minimal.nix
  ];

  documentation.man.enable = lib.mkOverride 500 true;
}
