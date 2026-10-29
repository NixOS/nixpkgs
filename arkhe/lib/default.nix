# Reexporta os construtores para uso por terceiros:
#
#   let
#     arkheLib = import (nixpkgs-arkhe + "/lib") { inherit pkgs; };
#     ws = arkheLib.workspace { root = ./meu-workspace; };
#   in
#   (arkheLib.mkArkhePackage { workspace = ws; }) { pname = "..."; ... }
{ pkgs }:

{
  workspace = import ./workspace.nix { inherit (pkgs) lib; };

  mkArkhePackage =
    {
      workspace ? null,
      rustPlatform ? pkgs.rustPlatform,
    }:
    pkgs.callPackage ./mk-arkhe-package.nix { inherit workspace rustPlatform; };

  toolchain =
    { rust-bin, toolchainFile }:
    pkgs.callPackage ./toolchain.nix { inherit rust-bin toolchainFile; };
}
