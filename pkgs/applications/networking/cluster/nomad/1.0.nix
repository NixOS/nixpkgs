{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.0.6";
  sha256 = "1nzaw4014bndxv042dkxdj492b21r5v5f06vav2kr1azk4m9sf07";
}
