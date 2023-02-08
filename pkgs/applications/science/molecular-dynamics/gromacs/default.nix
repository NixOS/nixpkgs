{ lib, stdenv, fetchurl, cmake, hwloc, fftw, perl, blas, lapack, mpi, cudatoolkit
, singlePrec ? true
, enableMpi ? false
, enableCuda ? false
, cpuAcceleration ? null
}:

let
  # Select reasonable defaults for all major platforms
  # The possible values are defined in CMakeLists.txt:
  # AUTO None SSE2 SSE4.1 AVX_128_FMA AVX_256 AVX2_256
  # AVX2_128 AVX_512 AVX_512_KNL MIC ARM_NEON ARM_NEON_ASIMD
  SIMD = x: if (cpuAcceleration != null) then x else
    if stdenv.hostPlatform.system == "i686-linux" then "SSE2" else
    if stdenv.hostPlatform.system == "x86_64-linux" then "SSE4.1" else
    if stdenv.hostPlatform.system == "x86_64-darwin" then "SSE4.1" else
    if stdenv.hostPlatform.system == "aarch64-linux" then "ARM_NEON_ASIMD" else
    "None";

in stdenv.mkDerivation rec {
  pname = "gromacs";
  version = "2022.4";

  src = fetchurl {
    url = "ftp://ftp.gromacs.org/pub/gromacs/gromacs-${version}.tar.gz";
    sha256 = "sha256-xRG+YC/ylAIGW1CQaEHe+YdSY5uSqV8bChBg2bXicpc=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    fftw
    perl
    hwloc
    blas
    lapack
  ] ++ lib.optional enableMpi mpi
    ++ lib.optional enableCuda cudatoolkit
  ;

  propagatedBuildInputs = lib.optional enableMpi mpi;
  propagatedUserEnvPkgs = lib.optional enableMpi mpi;

  cmakeFlags = [
    "-DGMX_SIMD:STRING=${SIMD cpuAcceleration}"
    "-DGMX_OPENMP:BOOL=TRUE"
    "-DBUILD_SHARED_LIBS=ON"
  ] ++ (
    if singlePrec then [
      "-DGMX_DOUBLE=OFF"
    ] else [
      "-DGMX_DOUBLE=ON"
      "-DGMX_DEFAULT_SUFFIX=OFF"
    ]
  ) ++ (
    if enableMpi
      then [
        "-DGMX_MPI:BOOL=TRUE"
        "-DGMX_THREAD_MPI:BOOL=FALSE"
      ]
     else [
       "-DGMX_MPI:BOOL=FALSE"
     ]
  ) ++ lib.optional enableCuda "-DGMX_GPU=CUDA";

  postFixup = ''
    substituteInPlace "$out"/lib/pkgconfig/*.pc \
      --replace '=''${prefix}//' '=/' \
      --replace "$out/$out/" "$out/"
  '';

  meta = with lib; {
    homepage = "http://www.gromacs.org";
    license = licenses.gpl2;
    description = "Molecular dynamics software package";
    longDescription = ''
      GROMACS is a versatile package to perform molecular dynamics,
      i.e. simulate the Newtonian equations of motion for systems
      with hundreds to millions of particles.

      It is primarily designed for biochemical molecules like
      proteins, lipids and nucleic acids that have a lot of
      complicated bonded interactions, but since GROMACS is
      extremely fast at calculating the nonbonded interactions (that
      usually dominate simulations) many groups are also using it
      for research on non-biological systems, e.g. polymers.

      GROMACS supports all the usual algorithms you expect from a
      modern molecular dynamics implementation, (check the online
      reference or manual for details), but there are also quite a
      few features that make it stand out from the competition.

      See: https://www.gromacs.org/About_Gromacs for details.
    '';
    platforms = platforms.unix;
    maintainers = with maintainers; [ sheepforce markuskowa ];
  };
}
