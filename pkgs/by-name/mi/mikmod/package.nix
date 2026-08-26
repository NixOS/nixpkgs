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
  version = "3.2.9";

  src = fetchurl {
    url = "mirror://sourceforge/mikmod/mikmod-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-IUwQqjAZgHoesmsscJWS9j28wAtymFqoak+3rDzYuQE=";
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
