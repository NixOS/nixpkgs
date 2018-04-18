let
  version     = "1.10.1";
  sha256      = "0313ch4rqnwrsf7y1h8bdwjk59gvcj08jjf6sybb6ww0ml7a6i7b";
  cargoSha256 = "00jr4g3q40pc1wi7fmfq1j8iakmv9pid7l31rf76wj4n8g051zc7";
  patches     = [ ./patches/vendored-sources-1.10.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
