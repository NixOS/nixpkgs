{ lib, stdenv, fetchurl, cmake, gfortran, blas, lapack, mpi, petsc, python3 }:

stdenv.mkDerivation rec {
  pname = "getdp";
  version = "3.5.0";
  src = fetchurl {
    url = "http://getdp.info/src/getdp-${version}-source.tgz";
    sha256 = "sha256-C/dsSe+puIQBpFfBL3qr2XWXrUnvYy0/uTCKqOpDe9w=";
  };

  inherit (petsc) mpiSupport;
  nativeBuildInputs = [ cmake python3 ];
  buildInputs = [ gfortran blas lapack petsc ]
    ++ lib.optional mpiSupport mpi
  ;
  cmakeFlags = lib.optional mpiSupport "-DENABLE_MPI=1";

  meta = with lib; {
    description = "A General Environment for the Treatment of Discrete Problems";
    longDescription = ''
      GetDP is a free finite element solver using mixed elements to discretize
      de Rham-type complexes in one, two and three dimensions.  The main
      feature of GetDP is the closeness between the input data defining
      discrete problems (written by the user in ASCII data files) and the
      symbolic mathematical expressions of these problems.
    '';
    homepage = "http://getdp.info/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
