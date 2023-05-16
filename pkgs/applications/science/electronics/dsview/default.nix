<<<<<<< HEAD
{ stdenv, lib, fetchFromGitHub, pkg-config, cmake, wrapQtAppsHook
, libzip, boost, fftw, qtbase, qtwayland, qtsvg, libusb1
, python3, fetchpatch
}:

stdenv.mkDerivation rec {
  pname = "dsview";

  version = "1.3.0";
=======
{ lib, mkDerivation, fetchFromGitHub, pkg-config, cmake
, libzip, boost, fftw, qtbase, libusb1
, python3, fetchpatch
}:

mkDerivation rec {
  pname = "dsview";

  version = "1.2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
      owner = "DreamSourceLab";
      repo = "DSView";
      rev = "v${version}";
<<<<<<< HEAD
      sha256 = "sha256-wnBVhZ3Ky9PXs48OVvSbD1aAUSEqAwaNLg7Ntim7yFM=";
=======
      sha256 = "sha256-QaCVu/n9PDbAiJgPDVN6SJMILeUO/KRkKcHYAstm86Q=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  patches = [
    # Fix absolute install paths
    ./install.patch
  ];

<<<<<<< HEAD
  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];

  buildInputs = [
    boost fftw qtbase qtwayland qtsvg libusb1 libzip
=======
  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    boost fftw qtbase libusb1 libzip
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
