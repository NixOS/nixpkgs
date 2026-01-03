{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "maskromtool";
  version = "2024-08-18";

  src = fetchFromGitHub {
    owner = "travisgoodspeed";
    repo = "maskromtool";
    rev = "v${version}";
    hash = "sha256-iuCjAAVEKVwJuAgKITwkXGhKau2DVWhFQLPjp28tjIo=";
  };

  buildInputs = [
    qt6.qtbase
    qt6.qtcharts
    qt6.qttools
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  meta = {
    description = "CAD tool for extracting bits from Mask ROM photographs";
    homepage = "https://github.com/travisgoodspeed/maskromtool";
    license = [
      lib.licenses.beerware
      lib.licenses.gpl1Plus
    ];
    maintainers = [
      lib.maintainers.evanrichter
    ];
  };
}
