{ pkgs, ... }:

{
  imports = [
    ../../profiles/new-kernel.nix
    ./installation-cd-minimal.nix
  ];
}
