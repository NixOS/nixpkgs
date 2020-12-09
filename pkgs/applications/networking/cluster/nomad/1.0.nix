{ callPackage, buildGoPackage }:

callPackage ./generic.nix {
  inherit buildGoPackage;
  version = "1.0.1";
  sha256 = "07k81csyxhgc7bgn297zlqyvc55qb5fmiavi7dk81rdpg5m2zjvv";
}
