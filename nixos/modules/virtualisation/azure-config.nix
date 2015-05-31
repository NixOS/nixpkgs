{ config, pkgs, ... }:

{
  imports = [ <nixpkgs/nixos/modules/virtualisation/azure-image.nix> ];
}
