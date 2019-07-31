let
  version     = "2.5.5";
  sha256      = "193fnrf1pr67wblyxd5gbrg1rgflphnfaxgm3kb4iawjh18br6c6";
  cargoSha256 = "1w9p43v76igb62mbjk2rl7fynk13l4hpz25jd4f4hk5b2y2wf3r7";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
