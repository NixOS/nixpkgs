let
  version     = "2.2.8";
  sha256      = "1l2bxra4fkbh8gnph9wnc24ddmzfdclsgcjbx8q6fflhcg6r9hf1";
  cargoSha256 = "10lg0vzikzlj927hpn59x1dz9dvhcaqsl8nz14vj2iz42vfkcm7p";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
