{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation {
  pname = "bklk";
  version = "0-unstable-2020-12-29";

  src = fetchFromGitHub {
    owner = "Ruunyox";
    repo = "bklk";
    rev = "26f3420aa5726e152a745278ddb98dc99c0a935e";
    sha256 = "sha256-R3H6tv6fzQG41Y2rui0K8fdQ/+Ywnc5hqTPFjktrhF8=";
  };

  makeFlags = [ "CC=$$CXX" ];

  buildInputs = [ ncurses ];

  installPhase = ''
    mkdir -p $out/bin
    cp bklk $out/bin
  '';

  meta = {
    description = "Ncurses Binary Clock";
    longDescription = "bklk is a simple binary clock for your terminal.";
    homepage = "https://github.com/Ruunyox/bklk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ j0hax ];
    platforms = lib.platforms.all;
    mainProgram = "bklk";
  };
}
