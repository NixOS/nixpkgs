{ callPackage
, buildGoModule
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./genericModule.nix {
  inherit buildGoModule nvidia_x11 nvidiaGpuSupport;
  version = "1.1.5";
  sha256 = "03gxh12bd5mj1l4q3xilil806dsqaqmz93ff7ysf441frgkx3iy3";
  vendorSha256 = "0rfd22rf76mwj489zhswah4g3dhhz6davm336xgm9dbnyaz9d8r0";
}
