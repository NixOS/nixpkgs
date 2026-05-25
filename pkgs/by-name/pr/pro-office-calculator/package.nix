{
  stdenv,
  lib,
  fetchFromGitHub,
  tinyxml-2,
  cmake,
  qt5,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "1.0.13";
  pname = "pro-office-calculator";

  src = fetchFromGitHub {
    owner = "RobJinman";
    repo = "pro_office_calc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7cYItmWOBDP/ajanwYnyBZobVny/9HumI7e+rLRn5ew=";
  };

  buildInputs = [
    qt5.qtbase
    qt5.qtmultimedia
    tinyxml-2
  ];

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];

  meta = {
    description = "Completely normal office calculator";
    mainProgram = "procalc";
    homepage = "https://proofficecalculator.com/";
    maintainers = with lib.maintainers; [ pmiddend ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
  };
})
