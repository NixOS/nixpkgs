{ callPackage }:

builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  zettlr = {
    version = "3.4.4";
    hash = "sha256-ApgmHl9WoAmWl03tqv01D0W8orja25f7KZUFLhlZloQ=";
  };
}
