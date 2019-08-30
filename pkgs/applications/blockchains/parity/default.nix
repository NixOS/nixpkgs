let
  version     = "2.5.6";
  sha256      = "1qkrqkkgjvm27babd6bidhf1n6vdp8rac1zy5kf61nfzplxzr2dy";
  cargoSha256 = "0aa0nkv3jr7cdzswbxghxxv0y65a59jgs1682ch8vrasi0x17m1x";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
