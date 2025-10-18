{ lib, pkgs }:
lib.makeScope pkgs.newScope (
  final:
  let
    inherit (final) callPackage;
    example-builder = import ./main-repo-plugin-builder.nix;
  in
  builtins.listToAttrs (
    map
      (name: {
        inherit name;
        value = callPackage example-builder { inherit name; };
      })
      [
        "wikimedia"
        "coverartarchive"
        "crypto-ticker"
        "discord-rich-presence"
        "subsonicapi-demo"
      ]
  )
)
