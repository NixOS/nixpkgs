{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "caneda";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "Caneda";
    repo = "Caneda";
    rev = finalAttrs.version;
    sha256 = "sha256-oE0cdOwufc7CHEFr3YU8stjg1hBGs4bemhXpNTCTpDQ=";
  };

  patches = [
    (fetchpatch {
      url = "https://sources.debian.org/data/main/c/caneda/0.4.0-2/debian/patches/fix_cmake_minimum_version.patch";
      hash = "sha256-MRkCA0GWcI6yEo4Ej+F67k0iNG1JHeLNhH0Rbz1QWoA=";
    })
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.qt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qttools
    libsForQt5.qtsvg
    libsForQt5.qwt6_1
  ];

  meta = {
    description = "Open source EDA software focused on easy of use and portability";
    changelog = "https://github.com/Caneda/Caneda/releases/tag/${finalAttrs.version}";
    mainProgram = "caneda";
    homepage = "http://caneda.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ magicquark ];
    platforms = with lib.platforms; linux;
  };
})
