{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.1.2";
  sha256 = "08ynfr2lqzv66ymj37qbc72lf2iq41kf94n76pdvynymk4dq98nq";
}
