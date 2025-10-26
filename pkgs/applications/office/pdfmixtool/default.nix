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

stdenv.mkDerivation rec {
  pname = "pdfmixtool";
  version = "1.2.1";

  src = fetchFromGitLab {
    owner = "scarpetta";
    repo = "pdfmixtool";
    rev = "v${version}";
    hash = "sha256-UuRTMLlUIyo2RF+XjI229kkE67ybmllIy98p97PjWCE=";
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

  meta = with lib; {
    description = "Application to split, merge, rotate and mix PDF files";
    mainProgram = "pdfmixtool";
    homepage = "https://gitlab.com/scarpetta/pdfmixtool";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };
}
