{
  lib,
  stdenv,
  gfortran,
  blas,
  lapack,
  scalapack,
  useMpi ? false,
  mpi,
  fetchFromGitLab,
  fetchpatch,
  cmake,
  pkg-config,
  readline,
  ninja,
  elpa,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "siesta";
  version = "5.4.2";

  src = fetchFromGitLab {
    owner = "siesta-project";
    repo = "siesta";
    tag = finalAttrs.version;
    hash = "sha256-J6cR8h6wMaofNLcTVyH9cr59FN533GhkviOQ4/5whIM=";
    fetchSubmodules = true;
  };

  patches = [
    # upstream patch, remove with next upgrade
    (fetchpatch {
      name = "gcc-bug-125383";
      url = "https://gitlab.com/siesta-project/siesta/-/commit/bb6d7f5493c19078ecc236cf36b8672eeaf228c8.patch";
      hash = "sha256-p7jE5m055m0XW/lJHtyHYmGIJ3Dz+5sLy0jcG/zyAqg=";
    })
  ];

  passthru = {
    inherit mpi;
    updateScript = nix-update-script { };
  };

  nativeBuildInputs = [
    ninja
    gfortran
    cmake
    pkg-config
  ];

  buildInputs = [
    blas
    lapack
    readline
    elpa
  ]
  ++ lib.optionals useMpi [
    mpi
    scalapack
  ];

  env.NIX_LDFLAGS = "-lm";

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  enableParallelBuilding = true;

  preBuild =
    if useMpi then
      ''
        makeFlagsArray+=(
            CC="mpicc" FC="mpifort"
            FPPFLAGS="-DMPI" MPI_INTERFACE="libmpi_f90.a" MPI_INCLUDE="."
            COMP_LIBS="" LIBS="-lblas -llapack -lscalapack"
        );
      ''
    else
      ''
        makeFlagsArray+=(
          COMP_LIBS="" LIBS="-lblas -llapack"
        );
      '';

  meta = {
    description = "First-principles materials simulation code using DFT";
    mainProgram = "siesta";
    longDescription = ''
      SIESTA is both a method and its computer program
      implementation, to perform efficient electronic structure
      calculations and ab initio molecular dynamics simulations of
      molecules and solids. SIESTA's efficiency stems from the use
      of strictly localized basis sets and from the implementation
      of linear-scaling algorithms which can be applied to suitable
      systems. A very important feature of the code is that its
      accuracy and cost can be tuned in a wide range, from quick
      exploratory calculations to highly accurate simulations
      matching the quality of other approaches, such as plane-wave
      and all-electron methods.
    '';
    homepage = "https://siesta-project.org/siesta/";
    license = lib.licenses.gpl2;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.costrouc ];
  };
})
