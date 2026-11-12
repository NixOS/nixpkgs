{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  exiv2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pineapple-pictures";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "BLumia";
    repo = "pineapple-pictures";
    rev = finalAttrs.version;
    hash = "sha256-xCHQnujL7xXLg3I9h067v/1g/Xk5CyK5JPDZ6o4Yhxg=";
  };

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtsvg
    exiv2
  ];

  cmakeFlags = [
    "-DPREFER_QT_5=OFF"
  ];

  meta = {
    description = "Homebrew lightweight image viewer";
    homepage = "https://github.com/BLumia/pineapple-pictures";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "ppic";
    maintainers = with lib.maintainers; [ wineee ];
  };
})
