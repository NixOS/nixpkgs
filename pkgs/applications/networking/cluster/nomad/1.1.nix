{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.1.0";
  sha256 = "0sz6blyxyxi5iq170s9v4nndb1hpz603z5ps2cxkdkaafal39767";
}
