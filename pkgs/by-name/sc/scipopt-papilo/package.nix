{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  boost,
  blas,
  gmp,
  onetbb,
  gfortran,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scipopt-papilo";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "papilo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oxuXv/xWQiApxrrVdH3aEUOp40Em6kCz/DJXXpCxdzs=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    blas
    gmp
    gfortran
    boost
    onetbb
  ];

  cmakeFlags = [
    # Disable automatic download of TBB.
    (lib.cmakeBool "TBB_DOWNLOAD" false)

    # Explicitly disable SoPlex as a built-in back-end solver to avoid this error:
    #   > include/boost/multiprecision/mpfr.hpp:22: fatal error: mpfr.h: No such file or directory
    #   > compilation terminated.
    (lib.cmakeBool "SOPLEX" false)
  ];
  doCheck = true;
  meta = {
    maintainers = with lib.maintainers; [ fettgoenner ];
    description = "Parallel Presolve for Integer and Linear Optimization";
    license = lib.licenses.lgpl3Plus;
    homepage = "https://github.com/scipopt/papilo";
    mainProgram = "papilo";
  };
})
