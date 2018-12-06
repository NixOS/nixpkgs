let
  version     = "2.2.1";
  sha256      = "1m65pks2jk83j82f1i901p03qb54xhcp6gfjngcm975187zzvmcq";
  cargoSha256 = "1mf1jgphwvhlqkvzrgbhnqfyqgf3ljc1l9zckyilzmw5k4lf4g1w";
  patches     = [
    ./patches/vendored-sources-2.2.patch
  ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
