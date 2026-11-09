{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  bison,
  check,
  flex,
  gitUpdater,
  gmp,
  gtk3,
  pkg-config,
  libsForQt5,

  withGUI ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpsolve";
  version = "3.2.2";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "robol";
    repo = "MPSolve";
    rev = "de7ebfc7afc4834a0c9f92a04be7abdf5943d446";
    hash = "sha256-BGXvNxWUbto0yMIpEIxZ9wOYv9w0ev4OgVcniNYIKoU=";
  };

  patches = [
    (fetchpatch {
      name = "include-cmath-in-c++-before-defining-isnan-macro.patch";
      url = "https://github.com/robol/MPSolve/commit/260432c9d1002261f60159d0520af7862d4471ed.patch";
      hash = "sha256-ODWpp966S1SsSN8hf7yuYgJR44GgbLwSxui280WWGmM=";
    })
  ];

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    pkg-config
  ]
  ++ lib.optionals withGUI [
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    gmp
  ]
  ++ lib.optionals withGUI [
    gtk3
    libsForQt5.qtbase
  ];

  configureFlags = [
    (lib.enableFeature withGUI "graphical-debugger")
    (lib.enableFeature withGUI "ui")
  ];

  enableParallelBuilding = true;

  doCheck = true;

  checkInputs = [ check ];

  checkTarget = "check";

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://numpi.dm.unipi.it/scientific-computing-libraries/mpsolve/";
    description = "Multiprecision Polynomial Solver";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ kilianar ];
    mainProgram = "mpsolve";
  };
})
