{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  gfortran,
  autoreconfHook,
  pkg-config,
  openblas,
  fftwFloat,
  cfitsio,
}:

stdenv.mkDerivation {
  pname = "sextractor";
  version = "unstable-2026-03-11";

  src = fetchFromGitHub {
    owner = "astromatic";
    repo = "sextractor";
    rev = "1fd40628fec352b8ca394dee111696299bddfcb6";
    hash = "sha256-9NY8o7/BRb+KIG4tD+vIjxaEQ7zEgnA2MUSovDew+gY=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/astromatic/sextractor/pull/93.patch";
      hash = "sha256-I1PpsjPhnCC2BTVzDDWxFmbQWxaOfUzI4EK0h4OkOPA=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    gfortran
  ];

  buildInputs = [
    openblas
    fftwFloat
    cfitsio
  ];

  configureFlags = [ "--enable-openblas" ];

  meta = with lib; {
    description = "Extract catalogs of sources from astronomical images";
    homepage = "https://www.astromatic.net/software/sextractor/";
    license = licenses.gpl3;
    maintainers = [ maintainers.db8le ];
    platforms = platforms.unix;
  };
}
