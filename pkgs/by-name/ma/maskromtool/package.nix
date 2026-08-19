{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  yara-x,
  replxx,
  readline,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "maskromtool";
  version = "2026-07-04";

  src = fetchFromGitHub {
    owner = "travisgoodspeed";
    repo = "maskromtool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QO2s+nGmf0XTq+PRcIqjEeuc6djzQv8TcJjlYYs/X5c=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # remove hardcoded PKG_CONFIG_PATH
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'set(ENV{PKG_CONFIG_PATH} "c:/lib/pkgconfig;/usr/local/lib64")' \
        ""
  '';

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_TRY_FIND_PACKAGE_MODE" "ALWAYS")
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtcharts
    qt6.qttools
    yara-x
    replxx
    readline
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  meta = {
    description = "CAD tool for extracting bits from Mask ROM photographs";
    homepage = "https://github.com/travisgoodspeed/maskromtool";
    changelog = "https://github.com/travisgoodspeed/maskromtool/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      beerware
      gpl1Plus
    ];
    maintainers = with lib.maintainers; [ evanrichter ];
    mainProgram = "maskromtool";
  };
})
