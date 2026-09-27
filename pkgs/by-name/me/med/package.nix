{
  stdenv,
  lib,
  qt6,
  fetchFromGitHub,
  cmake,
  pkg-config,
  jsoncpp,
  icu,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "med";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "allencch";
    repo = "med";
    rev = finalAttrs.version;
    hash = "sha256-BUo/tzfuQmoIf8ofi0rvpXiMroOcoaaeNxyfYEVV8hw=";
  };

  patches = [ ./stringstream.patch ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    cmake
    pkg-config
  ];
  buildInputs = [
    qt6.qtbase
    qt6.qttools
    qt6.qtwayland
    jsoncpp
    icu
  ];

  meta = {
    description = "GUI game memory scanner and editor";
    homepage = "https://github.com/allencch/med";
    changelog = "https://github.com/allencch/med/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ zebreus ];
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    mainProgram = "med-ui";
  };
})
