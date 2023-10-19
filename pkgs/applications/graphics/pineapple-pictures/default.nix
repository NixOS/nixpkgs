{ lib
, stdenv
, fetchFromGitHub
, qtsvg
, qtwayland
, qttools
, exiv2
, wrapQtAppsHook
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pineapple-pictures";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "BLumia";
    repo = "pineapple-pictures";
    rev = finalAttrs.version;
    hash = "sha256-dD0pHqw1Gxp+yxzYdm2ZgxiHKyuJKBGYpjv99B1Da1g=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtsvg
    qtwayland
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
