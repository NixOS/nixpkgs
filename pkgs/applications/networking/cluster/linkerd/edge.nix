{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "24.9.3";
  sha256 = "1vm6f8abain3zjs3jymr62p7lk475av38pljczgb13fgnn2w6qii";
  vendorHash = "sha256-w7TchPXGQQSWcCVf4BMvh5U8qnkctgJAl0sHL6ml/8Y=";
}
