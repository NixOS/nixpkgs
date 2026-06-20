#!/usr/bin/env -S nix-instantiate --eval --strict --json --arg unused true
# Unused argument to trigger nix-instantiate calling this function with the default arguments.
{
  # ci/inputs.nix was added 2026-06-13, so pinnedJson support can be removed ~2026-12-25 🎅
  pinnedJson ? null,
  inputs ? (
    if pinnedJson == null then
      import ./inputs.nix
    else
      let
        pinned = builtins.fromJSON (builtins.readFile pinnedJson);
      in
      {
        nixpkgs = fetchTarball {
          inherit (pinned.pins.nixpkgs) url;
          sha256 = pinned.pins.nixpkgs.hash;
        };
      }
  ),
  nixpkgs ? inputs.nixpkgs,
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
