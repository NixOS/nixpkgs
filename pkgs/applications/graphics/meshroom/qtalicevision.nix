{ lib
, stdenv
, cmake
, fetchFromGitHub
, alice-vision
, qtbase
, qtdeclarative
, qt3d
, qtcharts
, qttools
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "qtalicevision";
  version = "unstable-2023-01-18";

  src = fetchFromGitHub {
    owner = "alicevision";
    repo = pname;
    rev = "cba5efc6fc933206c147a10f079c427534bf2599";
    hash = "sha256-2nZctjGxTHK9mq8yOgqCpPwe/+KS7e7sML4F++a89GI=";
  };

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/${qtbase.qtQmlPrefix}/.."
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
    qttools
  ];

  buildInputs = [
    alice-vision
    qtbase
    qtdeclarative
    qt3d
    qtcharts
    # tbb_2021_8
  ];

  meta = {
    description = "3D Reconstruction Software";
    homepage = "https://github.com/alicevision/meshroom";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ tmarkus ];
  };
}
