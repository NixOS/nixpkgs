{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "0.12.12";
  sha256 = "0hz5fsqv8jh22zhs0r1yk0c4qf4sf11hmqg4db91kp2xrq72a0qg";
}
