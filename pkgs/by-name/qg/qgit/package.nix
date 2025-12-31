{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qgit";
  version = "2.13";

  src = fetchFromGitHub {
    owner = "tibirna";
    repo = "qgit";
    rev = "qgit-${finalAttrs.version}";
    hash = "sha256-hOx6FYccutycp+F3iesj48STFeBM/2r5cw2f5FkBIjY=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
  ];

  meta = {
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/tibirna/qgit";
    description = "Graphical front-end to Git";
    maintainers = with lib.maintainers; [
      peterhoeg
      markuskowa
    ];
    inherit (qt6.qtbase.meta) platforms;
    mainProgram = "qgit";
  };
})
