{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "0.12.10";
  sha256 = "12hlzjkay7y1502nmfvq2qkhp9pq7vp4zxypawnh98qvxbzv149l";
}
