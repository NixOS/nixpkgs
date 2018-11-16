let
  version     = "2.1.3";
  sha256      = "0il18r229r32jzwsjksp8cc63rp6cf6c0j5dvbfzrnv1zndw0cg3";
  cargoSha256 = "08dyb0lgf66zfq9xmfkhcn6rj070d49dm0rjl3v39sfag6sryz20";
  patches     = [
    ./patches/vendored-sources-2.1.patch
  ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
