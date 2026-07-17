{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
  perl,
  gmp,
  mpfr,
  libsForQt5,
  enableGist ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gecode";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "Gecode";
    repo = "gecode";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-i1geBYMO+edZJekKe/zO+kkgd/S4jSiSZnDLfSRlXwc=";
  };

  enableParallelBuilding = true;
  dontWrapQtApps = true;
  nativeBuildInputs = [
    bison
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
