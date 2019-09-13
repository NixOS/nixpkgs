let
  version     = "2.6.3";
  sha256      = "1sk2l00si230qrc414drj6gw3sk64ym090xq10qbzzbix8yb8fzq";
  cargoSha256 = "1q6cbms7j1h726bvq38npxkjkmz14b5ir9c4z7pb0jcy7gkplyxx";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
