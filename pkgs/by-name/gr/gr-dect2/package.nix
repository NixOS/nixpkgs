{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gnuradio,
  spdlog,
  mpir,
  boost,
  volk,
  python3Packages,
  gmpxx,
}:

stdenv.mkDerivation {
  pname = "gr-dect2";
  version = "0-unstable-2025-03-16";

  src = fetchFromGitHub {
    owner = "pavelyazev";
    repo = "gr-dect2";
    rev = "0d973fe433eebfe3eee6e7f2eeb1322f8976ab42";
    hash = "sha256-zb22toxkVeAeMm3PHRS8crZ1PejjkAhvCFgz30kiPzo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    gnuradio
    spdlog
    mpir
    boost
    volk
    python3Packages.pybind11
    gmpxx
    python3Packages.numpy
  ];

  meta = {
    description = "Gnuradio module for real-time decoding of unencrypted DECT voice chnanels";
    homepage = "https://github.com/pavelyazev/gr-dect2";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ felbinger ];
    platforms = lib.platforms.linux;
  };
}
