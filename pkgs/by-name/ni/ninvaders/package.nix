{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ninvaders";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "sf-refugees";
    repo = "ninvaders";
    rev = "v${finalAttrs.version}";
    hash = "sha256-EXIDPH1GGN5bHknMU5y2EChpdxE3DSKYW+Qq/YPmvPI=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ ncurses ];

  meta = {
    description = "Space Invaders clone based on ncurses";
    mainProgram = "ninvaders";
    homepage = "https://ninvaders.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ _1000101 ];
    platforms = lib.platforms.all;
  };
})
