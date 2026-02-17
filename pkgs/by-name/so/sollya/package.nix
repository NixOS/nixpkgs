{
  lib,
  stdenv,
  fetchurl,
  gmp,
  mpfr,
  mpfi,
  libxml2,
  fplll,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sollya";
  version = "8.0";

  src = fetchurl {
    url = "https://www.sollya.org/releases/sollya-${finalAttrs.version}/sollya-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-WNc0+aL8jmczwR+W0t+aslvvJNccQBIw4p8KEzmoEZI=";
  };

  buildInputs = [
    gmp
    mpfr
    mpfi
    libxml2
    fplll
  ];

  configureFlags = [
    "--with-xml2-config=${lib.getExe' (lib.getDev libxml2) "xml2-config"}"
  ];

  makeFlags = [
    "CFLAGS=-std=c17"
  ];

  doCheck = true;

  meta = {
    description = "Tool environment for safe floating-point code development";
    mainProgram = "sollya";
    homepage = "https://www.sollya.org/";
    license = lib.licenses.cecill-c;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ wegank ];
  };
})
