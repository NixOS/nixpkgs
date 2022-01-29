{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.0.16";
  sha256 = "sha256-anaHRgKLoUxcHUPRIX8aN7uzNPXVvKnalPTmZJchDUo=";
}
