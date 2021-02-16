{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.0.3";
  sha256 = "142rwpli8mbyg4vhhybnym34rk9w1ns4ddfhqjr1ygmxb1rlsngi";
}
