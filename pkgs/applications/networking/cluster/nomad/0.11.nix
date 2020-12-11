{ callPackage, buildGoPackage }:

callPackage ./generic.nix {
  inherit buildGoPackage;
  version = "0.11.7";
  sha256 = "sha256-wp1Je+I3iijD/pHHQtylMQhOiVhS6AT/y2/pUiLr0M4=";
}
