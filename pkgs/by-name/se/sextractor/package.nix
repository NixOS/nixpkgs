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
  version = "2.28.2-unstable-2026-03-11";

  strictDeps = true;
  __structuredAttrs = true;

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

  meta = {
    description = "Extract catalogs of sources from astronomical images";
    homepage = "https://www.astromatic.net/software/sextractor/";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.db8le ];
    platforms = lib.platforms.unix;
  };
}
