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

  # Take the SCIPOptSuite source since no other source exists publicly.
  src = fetchzip {
    url = "https://github.com/scipopt/scip/releases/download/v920/scipoptsuite-9.2.0.tgz";
    sha256 = "SaIo/U9cconmGRxEPV5M7IO6+L9wGCaXqxifefUzFk4=";
  };

  sourceRoot = "source/ug";

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
    description = "Ubiquity Generator framework to parallelize branch-and-bound based solvers";
    license = lib.licenses.lgpl3;
    homepage = "https://ug.zib.de";
  };
}
