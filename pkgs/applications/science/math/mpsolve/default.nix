{
  lib,
  stdenv,
  fetchurl,
  gmp,
  pkg-config,
  qtbase,
  wrapQtAppsHook,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpsolve";
  version = "3.2.1";

  src = fetchurl {
    url = "https://numpi.dm.unipi.it/_media/software/mpsolve/mpsolve-${finalAttrs.version}.tar.gz";
    hash = "sha256-PRFCiumrLgIPJMq/vNnk2bIuxXLPcK8NRP6Nrh1R544=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    gmp
    gtk3
    qtbase
  ];

  meta = {
    homepage = "https://numpi.dm.unipi.it/scientific-computing-libraries/mpsolve/";
    description = "Multiprecision Polynomial Solver";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kilianar ];
    mainProgram = "mpsolve";
    platforms = lib.platforms.linux;
  };
})
