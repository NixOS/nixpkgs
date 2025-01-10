{ callPackage }:

builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  zettlr = {
    version = "3.0.2";
    hash = "sha256-xwBq+kLmTth15uLiYWJOhi/YSPZVJNO6JTrKFojSDXA=";
  };
}
