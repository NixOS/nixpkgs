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
  version = "716";

  # To correlate scipVersion and version, check: https://scipopt.org/#news
  scipVersion = "9.2.3";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "soplex";
    rev = "release-${builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version}";
    hash = "sha256-v2lDtnY3O1nP8RYALqpeO8q4b3bUAKZe4b3QhtnGiGg=";
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
