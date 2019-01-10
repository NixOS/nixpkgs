let
  version     = "2.2.6";
  sha256      = "1zbkbj8njawqsqfd5bp64p1wm6paa7y3nkdxggj6ap6dbg6549v0";
  cargoSha256 = "1izwqg87qxhmmkd49m0k09i7r05sfcb18m5jbpvggjzp57ips09r";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
