{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  gfortran,
  blas,
  lapack,
  mpi,
  petsc,
  python3,
}:

let
  mpiSupport = petsc.passthru.mpiSupport;
in
stdenv.mkDerivation {
  pname = "getdp";
  version = "3.6.0-unstable-2025-10-25";

  src = fetchFromGitLab {
    domain = "gitlab.onelab.info";
    owner = "getdp";
    repo = "getdp";
    rev = "cac7f393ac34be1618b588083d2e391efd4976f7";
    hash = "sha256-yiqi9Fb3UM81iJtpU+Mg71BB73injdkWCzbJGgor4ww=";
  };

  nativeBuildInputs = [
    cmake
    python3
  ];
  buildInputs = [
    gfortran
    blas
    lapack
    petsc
  ]
  ++ lib.optional mpiSupport mpi;
  cmakeFlags = lib.optional mpiSupport "-DENABLE_MPI=1";

  meta = {
    description = "General Environment for the Treatment of Discrete Problems";
    mainProgram = "getdp";
    longDescription = ''
      GetDP is a free finite element solver using mixed elements to discretize
      de Rham-type complexes in one, two and three dimensions.  The main
      feature of GetDP is the closeness between the input data defining
      discrete problems (written by the user in ASCII data files) and the
      symbolic mathematical expressions of these problems.
    '';
    homepage = "http://getdp.info/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
