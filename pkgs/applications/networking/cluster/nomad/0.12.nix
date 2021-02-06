{ callPackage, buildGoPackage }:

callPackage ./generic.nix {
  inherit buildGoPackage;
  version = "0.12.10";
  sha256 = "12hlzjkay7y1502nmfvq2qkhp9pq7vp4zxypawnh98qvxbzv149l";
}
