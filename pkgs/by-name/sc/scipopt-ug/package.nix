{
  lib,
  stdenv,
  fetchzip,
  cmake,
  scipopt-scip,
  zlib,
  mpi,
  gmp,
  mpfr,
}:

stdenv.mkDerivation rec {
  pname = "scipopt-ug";
  version = "1.0.0";

  # To correlate scipVersion and version, check: https://scipopt.org/#news
  scipVersion = "10.0.0";

  # Take the SCIPOptSuite source since no other source exists publicly.
  src = fetchzip {
    url = "https://github.com/scipopt/scip/releases/download/v${scipVersion}/scipoptsuite-${scipVersion}.tgz";
    hash = "sha256-Nskb8quLsox7igz1UZCfd+VjR9Q8/oa8dZBYjAdc1EU=";
  };

  sourceRoot = "${src.name}/ug";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    scipopt-scip
    mpi
    zlib
    gmp
    mpfr
  ];

  meta = {
    maintainers = with lib.maintainers; [ fettgoenner ];
    changelog = "https://scipopt.org/doc-${scipVersion}/html/RN${lib.versions.major scipVersion}.php";
    description = "Ubiquity Generator framework to parallelize branch-and-bound based solvers";
    license = lib.licenses.lgpl3Plus;
    homepage = "https://ug.zib.de";
  };
}
