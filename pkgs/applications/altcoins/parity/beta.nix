let
  version     = "2.0.1";
  sha256      = "0rfq0izpswfwbyvr5kb6zjyf6sd7l1706c0sp7ccy6ykdfb4v6zs";
  cargoSha256 = "1ij17bfwvikqi5aj71j1nwf3jhkf3y9a0kwydajviwal47p9grl9";
  patches     = [ ./patches/vendored-sources-2.0.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
