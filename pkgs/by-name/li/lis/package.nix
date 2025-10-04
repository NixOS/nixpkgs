{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "lis";
  version = "2.1.10";

  src = fetchFromGitHub {
    owner = "anishida";
    repo = "lis";
    rev = "19359dce3fedda2ced2f22db3188761d449781c4";
    hash = "sha256-IVlxA2/Bko1s0TJTDrM7uuVa3bzvP5VTuywaqwWcG7Y=";
  };

  enableParallelBuilding = true;

  meta = {
    homepage = "https://www.ssisc.org/lis/";
    description = "Library of Iterative Solvers for linear systems";
    longDescription = ''
      Lis (Library of Iterative Solvers for linear systems, pronounced [lis])
      is a parallel software library to solve discretized linear equations and
      eigenvalue problems that arise from the numerical solution of
      partial differential equations using iterative methods.
    '';
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ neural-blade ];
    platforms = lib.platforms.unix;
  };
}
