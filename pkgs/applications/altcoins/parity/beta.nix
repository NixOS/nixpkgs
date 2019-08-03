let
  version     = "2.5.4";
  sha256      = "103kg0lrijf6d0mc1nk4pdgwgkmp9ga51rwfqrkkm133lylrr0lf";
  cargoSha256 = "1w9p43v76igb62mbjk2rl7fynk13l4hpz25jd4f4hk5b2y2wf3r7";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
