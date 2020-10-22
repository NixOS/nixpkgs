{ callPackage, buildGoPackage }:

callPackage ./generic.nix {
  inherit buildGoPackage;
  version = "0.11.5";
  sha256 = "0g7i7qd0zksd7s8y4l63kk7xdc7nrw8radba6ws3hw0h2kr2cmp8";
}
