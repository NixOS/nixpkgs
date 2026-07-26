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
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "Gecode";
    repo = "gecode";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-WhMN7QC+VQfvHUV1LLaW7I7fG++/fznh1ZDUY/Q8zD8=";
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
