{
  stdenv,
  lib,
  fetchFromGitHub,
  tinyxml-2,
  cmake,
  libsForQt5,
}:
stdenv.mkDerivation (finalAttrs: {
  version = "1.0.13";
  pname = "pro-office-calculator";

  src = fetchFromGitHub {
    owner = "RobJinman";
    repo = "pro_office_calc";
    tag = "v${finalAttrs.version}";
    sha256 = "1v75cysargmp4fk7px5zgib1p6h5ya4w39rndbzk614fcnv0iipd";
  };

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
    tinyxml-2
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  meta = {
    description = "Completely normal office calculator";
    mainProgram = "procalc";
    homepage = "https://proofficecalculator.com/";
    maintainers = with lib.maintainers; [ pmiddend ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
  };
})
