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
  version = "1.1";

  src = fetchFromGitLab {
    owner = "scarpetta";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-S8hhWZ6nHyIWPwsfl+o9XnljLD3aE/vthCLuWEbm5nc=";
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
    # fix incompatibility with qpdf11
    (fetchpatch {
      url = "https://gitlab.com/scarpetta/pdfmixtool/-/commit/81f7e96f6e68dfeba3cd4e00d8553dfdd2d7f2fa.diff";
      hash = "sha256-uBchYjUIqL7dJR7U/TSxhSGu1qY742cFUIv0XKU6L2g=";
    })

  ];

  meta = with lib; {
    description = "An application to split, merge, rotate and mix PDF files";
    homepage = "https://gitlab.com/scarpetta/pdfmixtool";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };
}

