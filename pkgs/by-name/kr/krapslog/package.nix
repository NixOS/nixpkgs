{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "krapslog";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "acj";
    repo = "krapslog-rs";
    rev = version;
    sha256 = "sha256-wRziLNMwLZBCn330FNC9x6loCCyuC+31Kh51ZI/j1Cc=";
  };

  cargoHash = "sha256-5jhEcwOdzLqzxQsEBqo4d5ecsg/vhiKuVjGYIwFzihE=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  meta = with lib; {
    description = "Visualize a log file with sparklines";
    homepage = "https://github.com/acj/krapslog-rs";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto ];
    mainProgram = "krapslog";
  };
}
