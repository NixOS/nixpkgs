{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, flex
, gitUpdater
, gmp
, gtk3
, pkg-config
, qtbase
, wrapQtAppsHook
, yacc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpsolve";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "robol";
    repo = "MPSolve";
    rev = finalAttrs.version;
    hash = "sha256-7lYwInodKj02G76xqhp/6e9MCzPY80gsAW3vTMNsfdA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    flex
    pkg-config
    wrapQtAppsHook
    yacc
  ];

  buildInputs = [
    gmp
    gtk3
    qtbase
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://numpi.dm.unipi.it/scientific-computing-libraries/mpsolve/";
    description = "Multiprecision Polynomial Solver";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kilianar ];
    mainProgram = "mpsolve";
    platforms = lib.platforms.linux;
  };
})
