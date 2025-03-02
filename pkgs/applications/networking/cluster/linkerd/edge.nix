{ callPackage }:

(callPackage ./generic.nix { }) {
  channel = "edge";
  version = "25.2.3";
  sha256 = "0qdvmn0pkw4clly51c2a8vpxskhvaa3crb2dvjm65yjq728d8h11";
  vendorHash = "sha256-3gMG0erlkeRLt+ZGOidB9NBAL7GkzaB5zQO9baZUsyE=";
}
