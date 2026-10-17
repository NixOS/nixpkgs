#!/usr/bin/env -S nix-instantiate --eval --strict --json --arg unused true
# Unused argument to trigger nix-instantiate calling this function with the default arguments.
{
  pinnedJson ? ./pinned.json,
}:
let
  pinned = (builtins.fromJSON (builtins.readFile pinnedJson)).pins;
  nixpkgs = fetchTarball {
    inherit (pinned.nixpkgs) url;
    sha256 = pinned.nixpkgs.hash;
  };
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
