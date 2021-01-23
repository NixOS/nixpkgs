{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "0.11.8";
  sha256 = "1dhh07bifr02jh2lls8fv1d9ra67ymgh8qxqvpvm0cd0qdd469z1";
}
