{
  lib,
  stdenv,
  cmake,
  gmp,
  mpfr,
  zlib,
  boost,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scipopt-soplex";
  version = "713";

  # To correlate scipVersion and version, check: https://scipopt.org/#news
  scipVersion = "9.2.1";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "soplex";
    rev = "release-${builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version}";
    hash = "sha256-qI7VGPAm3ALzeiD/OgvlZ1w2GzHRYdBajTW5XdIN9pU=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    gmp
    mpfr
    zlib
  ];

  strictDeps = true;

  doCheck = true;

  meta = {
    homepage = "https://soplex.zib.de/";
    description = "Sequential object-oriented simPlex";
    license = with lib.licenses; [ asl20 ];
    mainProgram = "soplex";
    maintainers = with lib.maintainers; [ david-r-cox ];
    changelog = "https://scipopt.org/doc-${finalAttrs.scipVersion}/html/RN${lib.versions.major finalAttrs.scipVersion}.php";
    platforms = lib.platforms.unix;
  };
})
