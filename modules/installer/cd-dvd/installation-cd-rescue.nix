# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.

{config, pkgs, ...}:

{
  require = [
    ./installation-cd-base.nix
    ../../profiles/rescue.nix
  ];
}
