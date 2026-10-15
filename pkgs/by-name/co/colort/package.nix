{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "colort";
  version = "0-unstable-2017-03-12";

  src = fetchFromGitHub {
    owner = "neeasade";
    repo = "colort";
    rev = "8470190706f358dc807b4c26ec3453db7f0306b6";
    hash = "sha256-vLfX7zqqWqmcB1P3nQVX0a0lr0FunM6gQR8aKPLKyII=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Program for 'tinting' color values";
    homepage = "https://github.com/neeasade/colort";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.neeasade ];
    mainProgram = "colort";
  };
}
