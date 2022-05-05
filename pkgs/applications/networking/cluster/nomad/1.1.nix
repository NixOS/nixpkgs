{ callPackage
, buildGoModule
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoModule nvidia_x11 nvidiaGpuSupport;
  version = "1.1.12";
  sha256 = "19y52sn4qz0vx9s188nf7rkr7y2cbq6h33l98sr4w85kmainn86s";
  vendorSha256 = "0p582y2q6zpyn7vmv1p8p8r2gbh786pqc6lpipgr7rpxbnxf5v4b";
}
