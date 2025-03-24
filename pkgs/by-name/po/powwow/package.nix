{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "powwow";
  version = "1.2.23";

  src = fetchurl {
    url = "https://www.hoopajoo.net/static/projects/powwow-${finalAttrs.version}.tar.gz";
    hash = "sha256-pnJu7zoEHcswJJo756pOBL9mF9jaQij0VYDcG5I0dPI=";
  };

  buildInputs = [
    ncurses
  ];

  meta = {
    description = "Multi-user Dungeon Client";
    homepage = "https://www.hoopajoo.net/projects/powwow.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    mainProgram = "powwow";
  };
})
