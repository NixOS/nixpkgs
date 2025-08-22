# TODO: Remove this file before merging
{ ... }@args:

let
  lib = import ../lib;
  release = import ./release-combined.nix args;

  addJob =
    jobs: jobAttr:
    let
      path = lib.splitString "." jobAttr;
    in
    lib.recursiveUpdate jobs (lib.setAttrByPath path (lib.getAttrFromPath path release));
in
lib.foldl' addJob {
  inherit (release) tested;
  nixos.tests = release.nixos.tests;
} release.tested.constituents
