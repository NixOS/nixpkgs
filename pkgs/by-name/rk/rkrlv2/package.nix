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

stdenv.mkDerivation (finalAttrs: {
  pname = "rkrlv2";
  version = "beta_3";

  src = fetchFromGitHub {
    owner = "ssj71";
    repo = "rkrlv2";
    tag = finalAttrs.version;
    hash = "sha256-WjpPNUEYw4aGrh57J+7kkxKFXgCJWNaWAmueFbNUJJo=";
  };

  postPatch = ''
    substituteInPlace ./CMakeLists.txt lv2/CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.6)" \
      "cmake_minimum_required(VERSION 4.0)"
  '';

  strictDeps = true;

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

  meta = {
    description = "Rakarrak effects ported to LV2";
    homepage = "https://github.com/ssj71/rkrlv2";
    license = lib.licenses.gpl2Only;
    maintainers = [ lib.maintainers.joelmo ];
    platforms = lib.platforms.unix;
    broken = stdenv.hostPlatform.isAarch64; # g++: error: unrecognized command line option '-mfpmath=sse'
  };
})
