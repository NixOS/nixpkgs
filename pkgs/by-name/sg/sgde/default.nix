let
  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/nixpkgs-unstable";
  pkgs = import nixpkgs { config = {}; overlays = []; };
in
{
  sglauncher = pkgs.callPackage ./sglauncher/package.nix { };
}
