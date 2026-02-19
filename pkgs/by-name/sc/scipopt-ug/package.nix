{
  lib,
  stdenv,
  fetchzip,
  cmake,
  scipopt-scip,
  zlib,
  mpi,
  gmp,
}:

stdenv.mkDerivation rec {
  pname = "scipopt-ug";
  version = "1.0.1";

  # To correlate scipVersion and version, check: https://scipopt.org/#news
  scipVersion = "10.0.1";

  # Take the SCIPOptSuite source since no other source exists publicly.
  src = fetchzip {
    url = "https://github.com/scipopt/scip/releases/download/v${scipVersion}/scipoptsuite-${scipVersion}.tgz";
    hash = "sha256-U5tbgGCzUkDL/22RwQLQmvCjSAhxehJe0P5rwNupW6Q=";
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
  ];

  meta = {
    maintainers = with lib.maintainers; [ fettgoenner ];
    changelog = "https://scipopt.org/doc-${scipVersion}/html/RN${lib.versions.major scipVersion}.php";
    description = "Ubiquity Generator framework to parallelize branch-and-bound based solvers";
    license = lib.licenses.lgpl3Plus;
    homepage = "https://ug.zib.de";
  };
}
