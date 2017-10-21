# This module defines a small netboot environment.

{ config, lib, ... }:

{
  imports =
    [ ./netboot-base.nix
      ../../profiles/minimal.nix
    ];
}
