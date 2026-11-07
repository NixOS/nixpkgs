#!/usr/bin/env -S nix-instantiate --eval --strict --json --arg unused true
# Unused argument to trigger nix-instantiate calling this function with the default arguments.
args@{
  # ci/inputs was added 2026-10-12, pinnedJson support can be removed ~2027-08-00
  pinnedJson ? null,
  flakeLock ? null,
  nixpkgs ? inputs.nixpkgs,
  inputs ? (
    if args ? pinnedJson then
      let
        pinned = builtins.fromJSON (builtins.readFile pinnedJson);
      in
      {
        nixpkgs = fetchTarball {
          inherit (pinned.pins.nixpkgs) url;
          sha256 = pinned.pins.nixpkgs.hash;
        };
      }
    else if args ? flakeLock then
      import ./inputs/read-inputs.nix flakeLock
    else
      import ./inputs
  ),
}:
let
  pkgs = import nixpkgs {
    config.allowAliases = false;
  };

  inherit (pkgs) lib;

  lix = lib.pipe pkgs.lixPackageSets [
    (lib.filterAttrs (_: set: lib.isDerivation set.lix or null && set.lix.meta.available))
    lib.attrNames
    (lib.filter (name: lib.match "lix_[0-9_]+|git" name != null))
    (map (name: "lixPackageSets.${name}.lix"))
  ];

  nix = lib.pipe pkgs.nixVersions [
    (lib.filterAttrs (_: drv: lib.isDerivation drv && drv.meta.available))
    lib.attrNames
    (lib.filter (name: lib.match "nix_[0-9_]+|git" name != null))
    (map (name: "nixVersions.${name}"))
  ];
in
lix ++ nix
