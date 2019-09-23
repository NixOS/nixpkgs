let
  version     = "2.6.2";
  sha256      = "1j4249m5k3bi7di0wq6fm64zv3nlpgmg4hr5hnn94fyc09nz9n1r";
  cargoSha256 = "1wr0i54zc3l6n0x6cvlq9zfy3bw9w5fcvdz4vmyym9r1nkvk31s7";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
