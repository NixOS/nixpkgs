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
  version = "714";

  # To correlate scipVersion and version, check: https://scipopt.org/#news
  scipVersion = "9.2.2";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "soplex";
    rev = "release-${builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version}";
    hash = "sha256-j5dsCAjEaReVpHHCM8FUyDIhxZ4P2yk2h89k5omTh8o=";
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
