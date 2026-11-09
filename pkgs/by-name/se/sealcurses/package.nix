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
  version = "0-unstable-2026-03-22"; # No release yet

  src = fetchFromGitea {
    domain = "git.skyjake.fi";
    owner = "skyjake";
    repo = "sealcurses";
    rev = "35c2e0332301f7aa14d3a849b30a844d65fa81bd";
    hash = "sha256-ILskZo5BNw4JK6n0ig2ULkUI7k9mdPjuk4VVEB7jx8c=";
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
