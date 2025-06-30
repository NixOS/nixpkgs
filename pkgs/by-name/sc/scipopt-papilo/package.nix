{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  boost,
  blas,
  gmp,
  tbb_2021,
  gfortran,
}:

stdenv.mkDerivation rec {
  pname = "scipopt-papilo";
  version = "2.4.2";

  # To correlate scipVersion and version, check: https://scipopt.org/#news
  scipVersion = "9.2.2";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "papilo";
    tag = "v${version}";
    hash = "sha256-/1AsAesUh/5YXeCU2OYopoG3SXAwAecPD88QvGkb2bY=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    blas
    gmp
    gfortran
    boost
    tbb_2021
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
