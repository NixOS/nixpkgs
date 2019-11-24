let
  version     = "2.5.10";
  sha256      = "0s8llcb1xdzs2zb6rnbsa9hck7dj4m8mamzkkvr0xjmgvigskf64";
  cargoSha256 = "16nf6y0hyffwdhxn1w4ms4zycs5lkzir8sj6c2lgsabig057hb6z";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
