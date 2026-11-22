{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
  pkg-config,
  ncurses,
  the-foundation,
}:

stdenv.mkDerivation {
  pname = "sealcurses";
  version = "0-unstable-2026-11-07"; # No release yet

  src = fetchFromCodeberg {
    owner = "skyjake";
    repo = "sealcurses";
    rev = "bdfc65f5270a734a238f93736eb3d9c82ad4848e";
    hash = "sha256-K1CIRldPr1+E/Pd2OE1ixILaWbm+C2cG74DgopHGAsU=";
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
    homepage = "https://codeberg.org/skyjake/sealcurses";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
}
