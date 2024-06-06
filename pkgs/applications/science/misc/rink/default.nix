{ lib, stdenv, fetchFromGitHub, rustPlatform, openssl, pkg-config, ncurses
, curl, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  version = "0.8.0";
  pname = "rink";

  src = fetchFromGitHub {
    owner = "tiffany352";
    repo = "rink-rs";
    rev = "v${version}";
    hash = "sha256-2+ZkyWhEnnO/QgCzWscbMr0u5kwdv2HqPLjtiXDfv/o=";
  };

  cargoHash = "sha256-j1pQfMjDNu57otOBTVBQEZIx80p4/beEUQdUkAJhvso=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses ]
    ++ (if stdenv.isDarwin then [ curl libiconv Security ] else [ openssl ]);

  # Some tests fail and/or attempt to use internet servers.
  doCheck = false;

  meta = with lib; {
    description = "Unit-aware calculator";
    mainProgram = "rink";
    homepage = "https://rinkcalc.app";
    license = with licenses; [ mpl20 gpl3Plus ];
    maintainers = with maintainers; [ sb0 Br1ght0ne ];
  };
}
