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
<<<<<<< HEAD
  version = "1.3.0";
=======
  version = "1.2.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "BLumia";
    repo = "pineapple-pictures";
    rev = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-Ek+/ZV0bagh+V7+3z1cZIqGRWsgY2oZSzqvvfuKpggU=";
=======
    hash = "sha256-wWu1nGAJ+8s7CIyFR0lJkxZ1C72Qvkfdvsw4Dvb4aKI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    maintainers = with lib.maintainers; [ wineee ];
  };
})
