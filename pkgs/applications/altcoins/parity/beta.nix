let
  version     = "2.5.1";
  sha256      = "0nnrgc2qyqqld3znjigryqpg5jaqh3jnmin4a334dbr4jw50dz3d";
  cargoSha256 = "184vfhsalk5dims3k13zrsv4lmm45a7nm3r0b84g72q7hhbl8pkf";
in
  import ./parity.nix { inherit version sha256 cargoSha256; }
