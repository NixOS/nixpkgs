{ callPackage, buildGoPackage }:

callPackage ./generic.nix {
  inherit buildGoPackage;
  version = "0.12.5";
  sha256 = "15cadw8rwdi7iphki8hg3jvxfh0cbxn4i0b1mds1j8z0s7j75mci";
}
