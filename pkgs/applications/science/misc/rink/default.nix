{ lib, stdenv, fetchFromGitHub, rustPlatform, openssl, pkg-config, ncurses
, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  version = "0.6.2";
  pname = "rink";

  src = fetchFromGitHub {
    owner = "tiffany352";
    repo = "rink-rs";
    rev = "v${version}";
    sha256 = "sha256-l2Rj15zaJm94EHwvOssfvYQNOoWj45Nq9M85n+A0vo4=";
  };

  cargoSha256 = "sha256-GhuvwVkDRFjC6BghaNMFZZG9hResTN1u0AuvIXlFmig=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ ncurses ]
    ++ (if stdenv.isDarwin then [ libiconv Security ] else [ openssl ]);

  # Some tests fail and/or attempt to use internet servers.
  doCheck = false;

  meta = with lib; {
    description = "Unit-aware calculator";
    homepage = "https://rinkcalc.app";
    license = with licenses; [ mpl20 gpl3Plus ];
    maintainers = with maintainers; [ sb0 Br1ght0ne ];
  };
}
