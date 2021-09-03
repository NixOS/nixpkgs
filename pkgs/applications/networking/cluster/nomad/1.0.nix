{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.0.10";
  sha256 = "1yd4j35dmxzg9qapqyq3g3hnhxi5c4f57q43xbim8255bjyn94f0";
}
