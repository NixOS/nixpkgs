{
  blas,
  boost,
  cmake,
  fetchFromGitHub,
  gfortran12,
  lib,
  stdenv,
  tbb,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "papilo";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "papilo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rB8kRyBxd+zn3XFueTQoN16jbFpXMvneqatQm8Hh2Hg=";
  };

  buildInputs = [
    blas
    boost
    cmake
    gfortran12
    zlib
  ];

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [ tbb ];

  strictDeps = true;

  doCheck = true;

  meta = with lib; {
    homepage = "https://scipopt.org/";
    description = "Parallel Presolve for Integer and Linear Optimization";
    license = with licenses; [ lgpl3Plus ];
    mainProgram = "papilo";
    maintainers = with maintainers; [ david-r-cox ];
    platforms = platforms.unix;
  };
})
