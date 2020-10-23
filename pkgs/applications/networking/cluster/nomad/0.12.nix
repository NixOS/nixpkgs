{ callPackage, buildGoPackage }:

callPackage ./generic.nix {
  inherit buildGoPackage;
  version = "0.12.7";
  sha256 = "0y1nwmpc4fqgjyb19n1f2w4y5k7fy4p68v2vnnry11nj3im7ia14";
}
