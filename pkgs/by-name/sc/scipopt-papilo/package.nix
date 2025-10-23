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

stdenv.mkDerivation rec {
  pname = "scipopt-papilo";
  version = "2.4.3";

  # To correlate scipVersion and version, check: https://scipopt.org/#news
  scipVersion = "9.2.3";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "papilo";
    tag = "v${version}";
    hash = "sha256-SsRAwidqvisoDODBLRatVWFw7wGeLUavmPXSlPmD7d8=";
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
    changelog = "https://scipopt.org/doc-${scipVersion}/html/RN${lib.versions.major scipVersion}.php";
    description = "Parallel Presolve for Integer and Linear Optimization";
    license = lib.licenses.lgpl3Plus;
    homepage = "https://github.com/scipopt/papilo";
    mainProgram = "papilo";
  };
}
