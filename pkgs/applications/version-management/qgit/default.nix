{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qtbase,
  qt5compat,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qgit";
  version = "2.12";

  src = fetchFromGitHub {
    owner = "tibirna";
    repo = "qgit";
    rev = "qgit-${finalAttrs.version}";
    hash = "sha256-q81nY9D/8riMTFP8gDRbY2PjVo+NwRu/XEN1Yn0P/pk=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qt5compat
  ];

  meta = {
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/tibirna/qgit";
    description = "Graphical front-end to Git";
    maintainers = with lib.maintainers; [
      peterhoeg
      markuskowa
    ];
    inherit (qtbase.meta) platforms;
    mainProgram = "qgit";
  };
})
