{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qtbase,
  qt5compat,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "qgit";
  version = "2.12";

  src = fetchFromGitHub {
    owner = "tibirna";
    repo = "qgit";
    rev = "qgit-${version}";
    hash = "sha256-q81nY9D/8riMTFP8gDRbY2PjVo+NwRu/XEN1Yn0P/pk=";
  };

  buildInputs = [
    qtbase
    qt5compat
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  meta = with lib; {
    license = licenses.gpl2Only;
    homepage = "https://github.com/tibirna/qgit";
    description = "Graphical front-end to Git";
    maintainers = with maintainers; [
      peterhoeg
      markuskowa
    ];
    inherit (qtbase.meta) platforms;
    mainProgram = "qgit";
  };
}
