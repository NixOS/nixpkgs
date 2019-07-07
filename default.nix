{ nixpkgs ? import <nixpkgs> {}}:
with nixpkgs;

let
  common = callPackage ./common.nix {};
  capt = callPackage ./capt.nix { cndrvcups-common = common;};
in
  capt
