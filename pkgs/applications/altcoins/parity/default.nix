let
  version     = "1.8.7";
  sha256      = "1bpkkf9yl2zpj7yzr34hf5kmn8mkj97ngwlmlgzvm38n04fbf05h";
  cargoSha256 = "1mf2xgj192h0kdb7b4wrh5cj1dgnjkjjvs0hw3bp1b3vc25rfbhz";
  patches     = [ ./patches/vendored-sources-1.8.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
