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
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "BLumia";
    repo = "pineapple-pictures";
    rev = finalAttrs.version;
    hash = "sha256-NWh0+DEfKT1iZY6tXVGuxgaXF5U+UB9S5BlWyD+1Bko=";
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
