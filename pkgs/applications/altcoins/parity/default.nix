let
  version     = "1.10.9";
  sha256      = "1irfksx887vvvdf97q26qacn22kmyj8fgb3ghh9wv5qnzrn3564g";
  cargoSha256 = "0rzhabyhprmcg0cdmibbb8zgqf6z4izsdq8m060mppkkv675x0lf";
  patches     = [ ./patches/vendored-sources-1.10.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
