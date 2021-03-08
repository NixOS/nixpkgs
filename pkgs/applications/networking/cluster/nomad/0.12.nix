{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "0.12.9";
  sha256 = "1a0ig6pb0z3qp7zk4jgz3h241bifmjlyqsfikyy3sxdnzj7yha27";
}
