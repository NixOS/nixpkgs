with import ./default.nix{};

stdenv.mkDerivation rec {
  name = "welp";

  buildInputs = [
    darwin.Libsystem
  ];
}
