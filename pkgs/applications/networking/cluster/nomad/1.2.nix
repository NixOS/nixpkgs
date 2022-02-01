{ callPackage
, buildGoModule
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoModule nvidia_x11 nvidiaGpuSupport;
  version = "1.2.3";
  sha256 = "0qjj1pnq2yv4r8dv03m08ii4118drjnswf4n1r95dqh8j3bymv5i";
  vendorSha256 = "0djh2184yg4b656wbhzxg1q1hsdnbrwsk79vc0426d0mqbzyy7dx";
}
