let
  version     = "2.2.4";
  sha256      = "12qcfmc56vnay25nlflgwhm3iwlr7hd286wzzanlsalizaj5s5ja";
  cargoSha256 = "11cwzqd459ld0apl2wnarfc4nb6j9j0dh26y3smvr0zsxvaz1r53";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
