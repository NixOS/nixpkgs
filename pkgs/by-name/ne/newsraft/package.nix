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

stdenv.mkDerivation (finalAttrs: {
  pname = "newsraft";
  version = "0.22";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "newsraft";
    repo = "newsraft";
    rev = "newsraft-${finalAttrs.version}";
    hash = "sha256-QjIADDk1PSZP89+G7B1Bpu3oTEAykD4RJYghZnMJKho=";
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
})
