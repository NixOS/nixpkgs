{ lib
, stdenv
, fetchFromGitLab
, cmake
, pkg-config
, ninja
, gfortran
, which
, perl
, procps
, libvdwxc
, libyaml
, libxc
, fftw
, blas
, lapack
, gsl
, netcdf
, arpack
, spglib
, metis
, scalapack
, mpi
, enableMpi ? true
, python3
}:

assert (!blas.isILP64) && (!lapack.isILP64);
assert (blas.isILP64 == arpack.isILP64);

stdenv.mkDerivation rec {
  pname = "octopus";
  version = "14.0";

  src = fetchFromGitLab {
    owner = "octopus-code";
    repo = "octopus";
    rev = version;
    sha256 = "sha256-wQ2I+10ZHLKamW3j6AUtq2KZVm6d29+JxYgwvBKz9DU=";
  };

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
  ] ++ lib.optional enableMpi scalapack;

  propagatedBuildInputs = lib.optional enableMpi mpi;
  propagatedUserEnvPkgs = lib.optional enableMpi mpi;

  cmakeFlags = [
    (lib.cmakeBool "OCTOPUS_MPI" enableMpi)
    (lib.cmakeBool "OCTOPUS_ScaLAPACK" enableMpi)
    (lib.cmakeBool "OCTOPUS_OpenMP" true)
  ];

  nativeCheckInputs = lib.optional.enableMpi mpi;
  doCheck = false;
  checkTarget = "check-short";

  postPatch = ''
    patchShebangs ./
  '';

  postConfigure = ''
    patchShebangs testsuite/oct-run_testsuite.sh
  '';

  enableParallelBuilding = true;

  passthru = lib.attrsets.optionalAttrs enableMpi { inherit mpi; };

  meta = with lib; {
    description = "Real-space time dependent density-functional theory code";
    homepage = "https://octopus-code.org";
    maintainers = with maintainers; [ markuskowa ];
    license = with licenses; [ gpl2Only asl20 lgpl3Plus bsd3 ];
    platforms = [ "x86_64-linux" ];
  };
}
