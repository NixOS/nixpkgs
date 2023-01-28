{ lib, mkDerivation, fetchFromGitHub, pkg-config, cmake
, libzip, boost, fftw, qtbase, libusb1
, python3, fetchpatch
}:

mkDerivation rec {
  pname = "dsview";

  version = "1.2.2";

  src = fetchFromGitHub {
      owner = "DreamSourceLab";
      repo = "DSView";
      rev = "v${version}";
      sha256 = "sha256-QaCVu/n9PDbAiJgPDVN6SJMILeUO/KRkKcHYAstm86Q=";
  };

  patches = [
    # Fix absolute install paths
    ./install.patch
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    boost fftw qtbase libusb1 libzip
    python3
  ];

  meta = with lib; {
    description = "A GUI program for supporting various instruments from DreamSourceLab, including logic analyzer, oscilloscope, etc";
    homepage = "https://www.dreamsourcelab.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bachp ];
  };
}
