{ lib, pkgs }:
lib.makeScope pkgs.newScope (
  final:
  let
    inherit (final) callPackage;
    main-repo-plugin-builder = import ./main-repo-plugin-builder.nix;
  in
  builtins.listToAttrs (
    map
      (name: {
        inherit name;
        value = callPackage main-repo-plugin-builder { inherit name; };
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
