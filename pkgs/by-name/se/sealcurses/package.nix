{
  lib,
  stdenv,
  fetchFromGitea,
  cmake,
  pkg-config,
  ncurses,
  the-foundation,
}:

stdenv.mkDerivation {
  pname = "sealcurses";
  version = "0-unstable-2024-12-02"; # No release yet

  src = fetchFromGitea {
    domain = "git.skyjake.fi";
    owner = "skyjake";
    repo = "sealcurses";
    rev = "310348a6b88678a47d371c7edfcc1e8c76ca1677";
    hash = "sha256-SEK3w6pVrYi+h2l5RuULpORYPnm8H78lEVR01cMkku0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    ncurses
    the-foundation
  ];

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" ];

  meta = {
    description = "SDL Emulation and Adaptation Layer for Curses (ncursesw)";
    homepage = "https://git.skyjake.fi/skyjake/sealcurses";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
}
