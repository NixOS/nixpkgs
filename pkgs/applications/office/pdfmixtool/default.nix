{ lib
, mkDerivation
, fetchFromGitLab
, fetchpatch
, cmake
, pkg-config
, qtbase
, qttools
, qpdf
, podofo
, imagemagick
}:

mkDerivation rec {
  pname = "pdfmixtool";
  version = "1.1.1";

  src = fetchFromGitLab {
    owner = "scarpetta";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fgtRKUG6J/CM6cXUTHWAPemqL8loWZT3wZmGdRHldq8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    imagemagick
    qtbase
    qttools
    qpdf
    podofo
  ];

  patches = [
    # fix incompatibility with qpdf11.3.0 usage of c++17 - delete this patch when we reach pdfmixtool version > v1.1.1
    (fetchpatch {
      url = "https://gitlab.com/scarpetta/pdfmixtool/-/commit/bd5f78c3a4d977d9b0c74302ce2521c737189b43.diff";
      hash = "sha256-h2g5toFqgEEnObd2TYQms1a1WFTgN7VsIHyy0Uyq4/I=";
    })
  ];

  meta = with lib; {
    description = "An application to split, merge, rotate and mix PDF files";
    homepage = "https://gitlab.com/scarpetta/pdfmixtool";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };
}

