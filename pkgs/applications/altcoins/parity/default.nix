let
  version     = "2.4.5";
  sha256      = "02ajwjw6cz86x6zybvw5l0pgv7r370hickjv9ja141w7bhl70q3v";
  cargoSha256 = "1n218c43gf200xlb3q03bd6w4kas0jsqx6ciw9s6h7h18wwibvf1";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
