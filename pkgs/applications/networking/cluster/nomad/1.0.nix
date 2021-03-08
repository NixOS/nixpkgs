{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.0.2";
  sha256 = "1l9j6k5dzh9ym9j75mam10vd9b5qh4xqfj6d63bjp7gkk4hd1jxx";
}
