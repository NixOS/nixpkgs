{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.0.13";
  sha256 = "19wlma2y8lpb7p01wb0l20rb6nvrvldz0mm3qfisx33y56ykjyh8";
}
