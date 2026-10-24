{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  boost,
  volk,
  fftw,
  fftwFloat,
  log4cpp,
  gmp,
  mpir,
  libiio,
  libad9361,
  spdlog,
  fmt,
  libsndfile,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "gnuradio-scopy";
  version = "0.1-unstable-2025-12-09";

  # branch scopy2-maint-3.10
  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "gnuradio";
    rev = "696841710f0ba38687af0873e4475860bd82da99";
    hash = "sha256-SEqmMdceQjkLMw8/RAugWAJmau7lE0HNH1n98pPr7Qo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    python3.pkgs.pybind11
  ];

  buildInputs = [
    boost
    volk
    fftw
    fftwFloat
    log4cpp
    gmp
    mpir
    libiio
    libad9361
    spdlog
    fmt
    libsndfile
  ];

  cmakeFlags = [
    "-DPYTHON_EXECUTABLE=${python3}/bin/python3"
    "-DENABLE_DEFAULT=OFF"
    "-DENABLE_GNURADIO_RUNTIME=ON"
    "-DENABLE_GR_ANALOG=ON"
    "-DENABLE_GR_BLOCKS=ON"
    "-DENABLE_GR_FFT=ON"
    "-DENABLE_GR_FILTER=ON"
    "-DENABLE_GR_IIO=ON"
    "-DENABLE_POSTINSTALL=OFF"
    "-DENABLE_TESTING=OFF"
    "-DENABLE_PYTHON=OFF"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch=scopy2-maint-3.10" ];
  };

  meta = {
    description = "GNU Radio fork with Scopy-specific patches";
    homepage = "https://github.com/analogdevicesinc/gnuradio";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ imadnyc ];
    platforms = lib.platforms.linux;
  };
}
