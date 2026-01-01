{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  fftw,
  rtl-sdr,
  libusb1,
}:

stdenv.mkDerivation {
  pname = "kalibrate-rtl";
  version = "0-unstable-2022-02-02";

  src = fetchFromGitHub {
    owner = "steve-m";
    repo = "kalibrate-rtl";
    rev = "340003eb0846b069c3edef19ed3363b8ac7b5215";
    sha256 = "n9mfu8H2OS8dKPNhtJxBfMDp8aHEIcxg/R+kcRNOBpk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    fftw
    rtl-sdr
    libusb1
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Calculate local oscillator frequency offset in RTL-SDR devices";
    longDescription = ''
      Kalibrate, or kal, can scan for GSM base stations in a given frequency
      band and can use those GSM base stations to calculate the local
      oscillator frequency offset.

      This package is for RTL-SDR devices.
    '';
    homepage = "https://github.com/steve-m/kalibrate-rtl";
<<<<<<< HEAD
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
=======
    license = licenses.bsd2;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      bjornfor
      viraptor
    ];
    mainProgram = "kal";
<<<<<<< HEAD
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
=======
    platforms = platforms.linux ++ platforms.darwin;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
