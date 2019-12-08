let
  version     = "2.6.6";
  sha256      = "1gx5qg9c588d5m564bnbly86663yrzb2hmlgv9zplwba7p0lpphl";
  cargoSha256 = "1xqmnirx2r91q5gy1skxl0f79xvaqzimq3l0cj4xvfms7mpdfbg1";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
