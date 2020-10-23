{ callPackage, buildGoPackage }:

callPackage ./generic.nix {
  inherit buildGoPackage;
  version = "0.11.6";
  sha256 = "09ym9fd4fp2461ddhrb5nlz8l24iq4hsbqikzc21ainagq2g1azf";
}
