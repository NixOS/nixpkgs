{ callPackage, buildGoPackage }:

callPackage ./generic.nix {
  inherit buildGoPackage;
  version = "0.12.9";
  sha256 = "1a0ig6pb0z3qp7zk4jgz3h241bifmjlyqsfikyy3sxdnzj7yha27";
}
