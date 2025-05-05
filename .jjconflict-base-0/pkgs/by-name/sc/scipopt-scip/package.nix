{
  lib,
  stdenv,
  fetchzip,
  fetchFromGitHub,
  cmake,
  zlib,
  readline,
  gmp,
  scipopt-soplex,
  scipopt-papilo,
  scipopt-zimpl,
  ipopt,
  tbb_2021_11,
  boost,
  gfortran,
  criterion,
  mpfr,
}:

stdenv.mkDerivation rec {
  pname = "scipopt-scip";
  version = "9.2.1";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "scip";
    tag = "v${lib.replaceStrings [ "." ] [ "" ] version}";
    hash = "sha256-xYxbMZYYqFNInlct8Ju0SrksfJlwV9Q+AHjxq7xhfAs=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    scipopt-soplex
    scipopt-papilo
    scipopt-zimpl
    ipopt
    gmp
    readline
    zlib
    tbb_2021_11
    boost
    gfortran
    criterion
    mpfr # if not included, throws fatal error: mpfr.h not found
  ];

  cmakeFlags = [ ];

  doCheck = true;

  meta = {
    maintainers = with lib.maintainers; [ fettgoenner ];
    changelog = "https://scipopt.org/doc-${version}/html/RN${lib.versions.major version}.php";
    description = "Solving Constraint Integer Programs";
    license = lib.licenses.asl20;
    homepage = "https://github.com/scipopt/scip";
    mainProgram = "scip";
  };
}
