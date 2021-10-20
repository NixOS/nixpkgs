{ lib
, mkDerivation
, fetchFromGitLab
, cmake
, pkg-config
, qtbase
, qttools
, qpdf
, podofo
}:

mkDerivation rec {
  pname = "pdfmixtool";
  version = "1.0.2";

  src = fetchFromGitLab {
    owner = "scarpetta";
    repo = pname;
    rev = "v${version}";
    sha256 = "066ap1w05gj8n0kvilyhlr1fzwrmlczx3lax7mbw0rfid9qh3467";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    qtbase
    qttools
    qpdf
    podofo
  ];

  meta = with lib; {
    description = "An application to split, merge, rotate and mix PDF files";
    homepage = "https://gitlab.com/scarpetta/pdfmixtool";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };
}

