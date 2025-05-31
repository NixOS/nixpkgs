{
  lib,
  stdenv,
  fetchFromGitHub,
  qt5,
}:

stdenv.mkDerivation (FinalAttrs: {
  pname = "pencil2d";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "pencil2d";
    repo = "pencil";
    tag = "v${FinalAttrs.version}";
    hash = "sha256-OuZpKgX2BgfuQdnjk/RTBww/blO1CIrYWr7KytqcIbQ=";
  };

  nativeBuildInputs = with qt5; [
    qmake
    wrapQtAppsHook
    qttools
  ];

  buildInputs = with qt5; [
    qtbase
    qtmultimedia
    qtsvg
    qtwayland
  ];

  meta = {
    description = "Easy, intuitive tool to make 2D hand-drawn animations";
    homepage = "https://www.pencil2d.org/";
    downloadPage = "https://github.com/pencil2d/pencil";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ agvantibo ];
    platforms = lib.platforms.linux;
    mainProgram = "pencil2d";
  };
})
