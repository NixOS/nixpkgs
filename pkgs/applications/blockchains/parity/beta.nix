let
  version     = "2.6.2";
  sha256      = "1j4249m5k3bi7di0wq6fm64zv3nlpgmg4hr5hnn94fyc09nz9n1r";
  cargoSha256 = "18zd91n04wck3gd8szj4vxn3jq0bzq0h3rg0wcs6nzacbzhcx2sw";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
