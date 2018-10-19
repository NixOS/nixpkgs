let
  version     = "2.0.8";
  sha256      = "1bz6dvx8wxhs3g447s62d9091sard2x7w2zd6iy7hf76wg0p73hr";
  cargoSha256 = "0wj93md87fr7a9ag73h0rd9xxqscl0lhbj3g3kvnqrqz9xxajing";
  patches     = [ ./patches/vendored-sources-2.0.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
