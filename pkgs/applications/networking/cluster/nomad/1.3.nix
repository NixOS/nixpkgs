{ callPackage
, buildGoModule
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoModule nvidia_x11 nvidiaGpuSupport;
  version = "1.3.0";
  sha256 = "098sg7jl257r6zfi2fsp9dwm0rrzi8m2k85bb097q14n3p4s3pna";
  vendorSha256 = "037bdgnyv8gkm2hz7h727ss46adnkywg28j6i1canmdacpi3qv5c";
}
