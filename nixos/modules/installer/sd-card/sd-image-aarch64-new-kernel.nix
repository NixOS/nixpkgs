{ pkgs, ... }:

{
  imports = [
    ../../profiles/new-kernel.nix
    ./sd-image-aarch64.nix
  ];
}
