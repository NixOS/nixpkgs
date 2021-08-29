{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.0.9";
  sha256 = "0ml6l5xq1310ib5zqfdwlxmsmhpc5ybd05z7pc6zgxbma1brxdv4";
}
