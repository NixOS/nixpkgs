{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maskromtool";
  version = "2024-08-18";

  src = fetchFromGitHub {
    owner = "travisgoodspeed";
    repo = "maskromtool";
    rev = "v${finalAttrs.version}";
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
    license = with lib.licenses; [
      beerware
      gpl1Plus
    ];
    maintainers = with lib.maintainers; [ evanrichter ];
  };
})
