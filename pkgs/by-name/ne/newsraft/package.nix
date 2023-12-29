{ lib
, stdenv
, fetchFromGitea
, pkg-config
, curl
, expat
, gumbo
, ncurses
, sqlite
, yajl
}:

stdenv.mkDerivation rec {
  pname = "newsraft";
  version = "0.21";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "grisha";
    repo = "newsraft";
    rev = "newsraft-${version}";
    hash = "sha256-vnLlozzPIk3F2U2ZvOClHnpmkXx4fc0pM1X4hFXM2Pg=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ curl expat gumbo ncurses sqlite yajl ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Feed reader for terminal";
    homepage = "https://codeberg.org/grisha/newsraft";
    license = licenses.isc;
    maintainers = with maintainers; [ arthsmn ];
    mainProgram = "newsraft";
    platforms = platforms.all;
  };
}
