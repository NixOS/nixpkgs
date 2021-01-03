{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.0.1";
  sha256 = "07k81csyxhgc7bgn297zlqyvc55qb5fmiavi7dk81rdpg5m2zjvv";
}
