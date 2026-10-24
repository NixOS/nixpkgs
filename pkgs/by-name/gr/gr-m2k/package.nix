{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gnuradio-scopy,
  gr-scopy,
  libm2k,
  volk,
  boost,
  spdlog,
  fmt,
  gmp,
  mpfr,
  python3,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "gr-m2k";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "gr-m2k";
    tag = "v${version}";
    hash = "sha256-1423dziEZHAnDA+pwNIEMD/hUpiecDg7v7ptvjqhSCA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    python3.pkgs.pybind11
  ];

  buildInputs = [
    gnuradio-scopy
    gr-scopy
    libm2k
    volk
    boost
    spdlog
    fmt
    gmp
    mpfr
  ];

  cmakeFlags = [
    "-DENABLE_PYTHON=OFF"
    "-DDIGITAL=OFF"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "M2K-specific GNU Radio blocks";
    homepage = "https://github.com/analogdevicesinc/gr-m2k";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ imadnyc ];
    platforms = lib.platforms.linux;
  };
}
