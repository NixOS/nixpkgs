{ callPackage
, buildGoModule
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoModule nvidia_x11 nvidiaGpuSupport;
  version = "1.3.5";
  sha256 = "sha256-WKS7EfZxysy/oyq1fa8rKvmfgHRiB7adSVhALZNFYgo=";
  vendorSha256 = "sha256-byc6wAxpqhxlN3kyHyFQeBS9/oIjHeoz6ldYskizgaI=";
}
