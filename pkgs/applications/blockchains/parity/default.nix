let
  version     = "2.5.11";
  sha256      = "1x2p559g2f30520v3kn46n737l5s1kwrn962dv73s6mb6n1lhs55";
  cargoSha256 = "16nf6y0hyffwdhxn1w4ms4zycs5lkzir8sj6c2lgsabig057hb6z";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
