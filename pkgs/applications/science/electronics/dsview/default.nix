{ stdenv, lib, fetchFromGitHub, pkg-config, cmake, wrapQtAppsHook
, libzip, boost, fftw, qtbase, qtwayland, qtsvg, libusb1
, python3, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "dsview";

  version = "1.3.1";

  src = fetchFromGitHub {
      owner = "DreamSourceLab";
      repo = "DSView";
      rev = "v${version}";
      sha256 = "sha256-LwrlB+Nwq34YjwGmnbUWS3W//ZHr8Do2Wf2te+2oBeI=";
  };

  patches = [
    # Fix absolute install paths
    ./install.patch
  ];

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];

  buildInputs = [
    boost fftw qtbase qtwayland qtsvg libusb1 libzip
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
