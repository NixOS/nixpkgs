let
  version     = "1.9.0";
  sha256      = "1m34960yq8s6qjdshlm9brghi9dgfnk18nfk8vzjfpsk7x7hcmli";
  cargoSha256 = "1vs56v7v02bfqrn9qx1wqbgzvrmaj0awy94w7iyib8zh8xkw8k7i";
  patches     = [ ./patches/vendored-sources-1.9.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
