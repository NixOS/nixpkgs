{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.0.12";
  sha256 = "04fqliz7y4zzs4xraid54mqxwgrzh138nmfcs876vp534slvikpi";
}
