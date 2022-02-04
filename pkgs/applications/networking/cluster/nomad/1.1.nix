{ callPackage
, buildGoModule
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoModule nvidia_x11 nvidiaGpuSupport;
  version = "1.1.8";
  sha256 = "05k1r157h3jaqzzsrkgc96zcny3mi8dvixc2v1w0lwcxixqk0y2l";
  vendorSha256 = "03hjin9nybf7fpbj5r82qh19qh3cc8m0b236mk0ajhsyjqrk8pir";
}
