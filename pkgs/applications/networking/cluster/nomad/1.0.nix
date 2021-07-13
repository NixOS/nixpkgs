{ callPackage
, buildGoPackage
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoPackage nvidia_x11 nvidiaGpuSupport;
  version = "1.0.8";
  sha256 = "1kjwa9lnxh5zfzijqgkp94wslkzn6kspwi42kf46vrn0qkiz39f2";
}
