{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/virtualisation/nova-image.nix> ];
}
