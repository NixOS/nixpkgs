{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.0.5";
  sha256 = "06l56fi4fhplvl8v0i88q18yh1hwwd12fngnrflb91janbyk6p4l";
}
