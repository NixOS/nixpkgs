{ callPackage
, buildGoModule
, nvidia_x11
, nvidiaGpuSupport
}:

callPackage ./genericModule.nix {
  inherit buildGoModule nvidia_x11 nvidiaGpuSupport;
  version = "1.1.3";
  sha256 = "0jpc8ff56k9q2kv9l86y3p8h3gqbvx6amvs0cw8sp4i7dqd2ihz2";
  vendorSha256 = "0az4gr7292lfr5wrwbkdknrigqm15lkbnf5mh517hl3yzv4pb8yr";
}
