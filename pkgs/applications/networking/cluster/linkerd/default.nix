{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "stable";
  version = "2.14.1";
  sha256 = "1fxwy8c1zcjwnv055czn9ixalpvq710k0m82633n73a0ixnlmjbv";
  vendorHash = "sha256-hOuvIndyGGvNWYmzE0rho/Y30/ilCzeBtL5GEvl9QqU=";
}
