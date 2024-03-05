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
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "BLumia";
    repo = "pineapple-pictures";
    rev = finalAttrs.version;
    hash = "sha256-UZVpyrUFf/uJNs2GHLYXpb81e7yzC8EFuoD+0Bzj6xQ=";
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
