{ callPackage, buildGoPackage }:

callPackage ./generic.nix {
  inherit buildGoPackage;
  version = "0.12.6";
  sha256 = "1fd7i50zc7g7d879bijh1ckvyq0h28169p6hw5ip71n71zhvvgp0";
}
