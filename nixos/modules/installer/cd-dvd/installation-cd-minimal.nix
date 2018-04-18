# This module defines a small NixOS installation CD.  It does not
# contain any graphical stuff.

{ config, lib, pkgs, ... }:

{
  imports =
    [ ./installation-cd-base.nix
    ];

  # Enable cloud-init so the image can also be used for cloud providers
  services.cloud-init.enable = true;
}
