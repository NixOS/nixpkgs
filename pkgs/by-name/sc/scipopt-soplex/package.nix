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
  version = "7.1.5";

  # To correlate scipVersion and version, check: https://scipopt.org/#news
  scipVersion = "9.2.3";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "soplex";
    rev = "release-${builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version}";
    hash = "sha256-gtz2h5EszE77zYZ8m2UtkYnoquO8GJhAAzsvQW5b+3I=";
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
