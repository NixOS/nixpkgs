{ lib, pkgs }:
lib.makeScope pkgs.newScope (
  final:
  let
    inherit (final) callPackage;
    main-repo-plugin-builder = import ./main-repo-plugin-builder.nix;
  in
  builtins.listToAttrs (
    map
      (data: {
        inherit (data) name;
        value = callPackage main-repo-plugin-builder { inherit (data) name
        vendorHash;
      };
      })
      [
        {
          name = "wikimedia";
          vendorHash = "sha256-DCz/WKZXnZy109WgStCK7NJg8VpR3IJEaQZLMDXdegk=";
        }
        { name = "coverartarchive"; vendorHash = lib.fakeHash; }
        { name = "crypto-ticker"; vendorHash = lib.fakeHash; }
        { name = "discord-rich-presence"; vendorHash = lib.fakeHash; }
        { name = "subsonicapi-demo"; vendorHash = lib.fakeHash; }
      ]
  )
)
