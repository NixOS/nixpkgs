{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  readline,
  gmp,
  scipopt-soplex,
  scipopt-papilo,
  scipopt-zimpl,
  ipopt,
  onetbb,
  boost,
  gfortran,
  criterion,
  mpfr,
}:

stdenv.mkDerivation rec {
  pname = "scipopt-scip";
  version = "9.2.4";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "scip";
    tag = "v${lib.replaceStrings [ "." ] [ "" ] version}";
    hash = "sha256-nwFRtP63/HPfk9JhcyLKApicgqE9IF+7s5MGGrVJrpM=";
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
    onetbb
    boost
    gfortran
    criterion
    mpfr # if not included, throws fatal error: mpfr.h not found
  ];

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
