{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  libmikmod,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mikmod";
  version = "3.2.10";

  src = fetchurl {
    url = "mirror://sourceforge/mikmod/mikmod-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-Rl6Z2J12Jgi30MChA6WO7GjIwormu9GWNUwTQz5A0go=";
  };

  buildInputs = [
    libmikmod
    ncurses
  ];

  meta = {
    description = "Tracker music player for the terminal";
    homepage = "http://mikmod.shlomifish.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
    mainProgram = "mikmod";
  };
})
