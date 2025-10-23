{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  ninja,
  gfortran,
  which,
  perl,
  procps,
  libvdwxc,
  libyaml,
  libxc,
  fftw,
  blas,
  lapack,
  gsl,
  netcdf,
  arpack,
  spglib,
  metis,
  scalapack,
  mpi,
  enableMpi ? true,
  python3,
}:

assert (!blas.isILP64) && (!lapack.isILP64);
assert (blas.isILP64 == arpack.isILP64);

stdenv.mkDerivation (finalAttrs: {
  pname = "octopus";
  version = "16.2";

  src = fetchFromGitLab {
    owner = "octopus-code";
    repo = "octopus";
    tag = finalAttrs.version;
    hash = "sha256-L97igB+bdZ19zpbffHi8DVSJXKtUyDqauUB+l5zzFwQ=";
  };

  outputs = [
    "out"
    "dev"
    "testsuite"
  ];

  nativeBuildInputs = [
    which
    perl
    procps
    cmake
    gfortran
    pkg-config
    ninja
  ];

  buildInputs = [
    libyaml
    libxc
    blas
    lapack
    gsl
    fftw
    netcdf
    arpack
    libvdwxc
    spglib
    metis
    (python3.withPackages (ps: [ ps.pyyaml ]))
  ]
  ++ lib.optional enableMpi scalapack;

  propagatedBuildInputs = lib.optional enableMpi mpi;
  propagatedUserEnvPkgs = lib.optional enableMpi mpi;

  cmakeFlags = [
    (lib.cmakeBool "OCTOPUS_MPI" enableMpi)
    (lib.cmakeBool "OCTOPUS_ScaLAPACK" enableMpi)
    (lib.cmakeBool "OCTOPUS_OpenMP" true)
    (lib.cmakeBool "OCTOPUS_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
  ];

  nativeCheckInputs = lib.optional enableMpi mpi;
  doCheck = false; # requires installed data

  postPatch = ''
    patchShebangs ./
  '';

  postConfigure = ''
    patchShebangs testsuite/oct-run_testsuite.sh
  '';

  postInstall = ''
    mkdir -p $testsuite
    moveToOutput share/octopus/testsuite $testsuite
  '';

  enableParallelBuilding = true;

  passthru = lib.attrsets.optionalAttrs enableMpi { inherit mpi; };

  meta = {
    description = "Real-space time dependent density-functional theory code";
    homepage = "https://octopus-code.org";
    maintainers = with lib.maintainers; [ markuskowa ];
    license = with lib.licenses; [
      gpl2Only
      asl20
      lgpl3Plus
      bsd3
    ];
    platforms = [ "x86_64-linux" ];
  };
})
