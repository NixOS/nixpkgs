A collection of NixOS modules covering hardware quirks.

Modules should favor usability and stability, so performance hacks
should be activated by an additional a NixOS option or conservative
and performance configs can be declared in seperate modules.

## Usage
The simplest way to use this repo for now is to clone locally and include by path:
``` nix
{ config, pkgs, ... }:

{
  imports =
    [ /home/user/nixos-hardware/acme/thunkpad-2000.nix ];
}
'''
