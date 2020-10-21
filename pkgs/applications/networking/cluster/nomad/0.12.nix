{ callPackage, buildGoPackage }:

callPackage ./generic.nix {
  inherit buildGoPackage;
  version = "0.12.3";
  sha256 = "100ynhc4nm4mmjxx1jhq2kjbqshxvi5x8y482520j8gsyn40g6zc";
}
