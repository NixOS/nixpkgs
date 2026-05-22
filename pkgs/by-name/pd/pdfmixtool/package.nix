{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  qt6Packages,
  qpdf,
  podofo,
  imagemagick,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdfmixtool";
  version = "1.2.2";

  src = fetchFromGitLab {
    owner = "scarpetta";
    repo = "pdfmixtool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+omL0WNU34BcWbsfK3FXfhp0DVWjm9Vb5OVjRCoT/IA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    imagemagick
    qt6Packages.poppler
    qt6Packages.qtbase
    qt6Packages.qttools
    qpdf
    podofo
  ];

  meta = {
    description = "Application to split, merge, rotate and mix PDF files";
    mainProgram = "pdfmixtool";
    homepage = "https://gitlab.com/scarpetta/pdfmixtool";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ onny ];
  };
})
