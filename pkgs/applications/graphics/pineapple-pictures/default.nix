{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6Packages,
  exiv2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pineapple-pictures";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "BLumia";
    repo = "pineapple-pictures";
    rev = finalAttrs.version;
    hash = "sha256-jdybJx/70m9c4/HC1Iz2xm3sf51Fl0jA0lhLvo+KwWw=";
  };

  nativeBuildInputs = [
    cmake
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.qtsvg
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
    maintainers = with lib.maintainers; [ rewine ];
  };
})
