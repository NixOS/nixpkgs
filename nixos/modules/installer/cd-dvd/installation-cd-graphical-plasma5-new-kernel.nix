{ pkgs, ... }:

{
  imports = [
    ../../profiles/new-kernel.nix
    ./installation-cd-graphical-plasma5.nix
  ];
}
