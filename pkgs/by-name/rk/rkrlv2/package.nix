{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  lv2,
  fftw,
  cmake,
  libXpm,
  libXft,
  libjack2,
  libsamplerate,
  libsndfile,
}:

stdenv.mkDerivation rec {
  pname = "rkrlv2";
  version = "beta_3";

  src = fetchFromGitHub {
    owner = "ssj71";
    repo = pname;
    rev = version;
    sha256 = "WjpPNUEYw4aGrh57J+7kkxKFXgCJWNaWAmueFbNUJJo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libXft
    libXpm
    lv2
    fftw
    libjack2
    libsamplerate
    libsndfile
  ];

  meta = with lib; {
    description = "Rakarrak effects ported to LV2";
    homepage = "https://github.com/ssj71/rkrlv2";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.joelmo ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isAarch64; # g++: error: unrecognized command line option '-mfpmath=sse'
  };
}
