{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gnuradio-scopy,
  volk,
  boost,
  spdlog,
  fmt,
  gmp,
  mpfr,
  python3,
  bison,
  flex,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "gr-scopy";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "gr-scopy";
    tag = "v${version}";
    hash = "sha256-8jR0jUsIJUVmS3T89MuqL9lyFWN36brmYz73Jja3Vwo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    python3.pkgs.pybind11
    bison
    flex
  ];

  buildInputs = [
    gnuradio-scopy
    volk
    boost
    spdlog
    fmt
    gmp
    mpfr
  ];

  cmakeFlags = [
    "-DENABLE_PYTHON=OFF"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Scopy IIO blocks for GNU Radio";
    homepage = "https://github.com/analogdevicesinc/gr-scopy";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ imadnyc ];
    platforms = lib.platforms.linux;
  };
}
