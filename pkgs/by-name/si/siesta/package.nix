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
  cmake,
  pkg-config,
  readline,
  ninja,
  elpa,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "siesta";
  version = "5.4.1";

  src = fetchFromGitLab {
    owner = "siesta-project";
    repo = "siesta";
    tag = finalAttrs.version;
    hash = "sha256-pud8RlJAT+0TwyPRsbf5D/8FfLjZvPYPf84Xb7UH6os=";
    fetchSubmodules = true;
  };

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

  NIX_LDFLAGS = "-lm";

  cmakeFlags = [
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  enableParallelBuilding = false; # Started making trouble with gcc-11

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
