{
  lib,
  stdenv,
  fetchzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lis";
  version = "2.1.24";

  src = fetchzip {
    url = "https://www.ssisc.org/lis/dl/lis-${finalAttrs.version}.zip";
    hash = "sha256-JFiMZjeov/4tbl2Gaiz2ibrP2jAdXicLdQ548wsgvkg=";
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
})
