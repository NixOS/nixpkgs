let
  version     = "1.10.8";
  sha256      = "0q6blsbxn48afqf3cmxvmdlyzvf0cpqcymsjbsk8nyx0zxzf1dpk";
  cargoSha256 = "0rzhabyhprmcg0cdmibbb8zgqf6z4izsdq8m060mppkkv675x0lf";
  patches     = [ ./patches/vendored-sources-1.10.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
