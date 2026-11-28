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
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "Gecode";
    repo = "gecode";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-k9zUA5plo2t7TUHq6FEXfiziY2G9UQu6Zhb9N34+xB4=";
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
