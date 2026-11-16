{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  cmake,
  flex,
  perl,
  gmp,
  mpfr,
  libsForQt5,
  enableGist ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gecode";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "Gecode";
    repo = "gecode";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-ZUNF2mACMdrxRMFlsf4us7tSOJvfJkY/cqiTL3hd7zM=";
  };

  enableParallelBuilding = true;
  dontWrapQtApps = true;
  nativeBuildInputs = [
    bison
    cmake
    flex
  ];
  buildInputs = [
    perl
    gmp
    mpfr
  ]
  ++ lib.optional enableGist libsForQt5.qtbase;

  meta = {
    license = lib.licenses.mit;
    homepage = "https://www.gecode.org";
    description = "Toolkit for developing constraint-based systems";
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
