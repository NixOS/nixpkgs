{ callPackage }:

builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  zettlr = {
    version = "3.4.3";
    hash = "sha256-Xb9zszbkHWAaIcu74EGQH0PVbuXIZXH/dja1F1Hkx1c=";
  };
}
