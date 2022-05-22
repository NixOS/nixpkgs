{ callPackage
, buildGoModule
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./generic.nix {
  inherit buildGoModule nvidia_x11 nvidiaGpuSupport;
  version = "1.1.14";
  sha256 = "0jzcmv6kw555lz7mrm673qgjfmzm4pznibbz9qn3w1jj4x9ddncy";
  vendorSha256 = "04nyd37viz521qb3frcy39alha0bpx029cy3kswldhh7wbyp7284";
}
