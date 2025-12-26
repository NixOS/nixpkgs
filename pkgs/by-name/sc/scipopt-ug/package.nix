{
  lib,
  stdenv,
  fetchzip,
  cmake,
  scipopt-scip,
  zlib,
  mpi,
}:

stdenv.mkDerivation rec {
  pname = "scipopt-ug";
  version = "1.0.0-beta6";

  # To correlate scipVersion and version, check: https://scipopt.org/#news
  scipVersion = "9.2.4";

  # Take the SCIPOptSuite source since no other source exists publicly.
  src = fetchzip {
    url = "https://github.com/scipopt/scip/releases/download/v${
      lib.replaceStrings [ "." ] [ "" ] scipVersion
    }/scipoptsuite-${scipVersion}.tgz";
    hash = "sha256-ZFgHaC4JL0eFt/do0ucGkarmfL1WdGEecrE1iPBpFh0=";
  };

  sourceRoot = "${src.name}/ug";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    scipopt-scip
    mpi
    zlib
  ];

  meta = {
    maintainers = with lib.maintainers; [ fettgoenner ];
    changelog = "https://scipopt.org/doc-${scipVersion}/html/RN${lib.versions.major scipVersion}.php";
    description = "Ubiquity Generator framework to parallelize branch-and-bound based solvers";
    license = lib.licenses.lgpl3Plus;
    homepage = "https://ug.zib.de";
  };
}
