let
  version     = "2.1.6";
  sha256      = "0njkypszi0fjh9y0zfgxbycs4c1wpylk7wx6xn1pp6gqvvri6hav";
  cargoSha256 = "116sj7pi50k5gb1i618g4pgckqaf8kb13jh2a3shj2kwywzzcgjs";
  patches     = [ ./patches/vendored-sources-2.1.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
