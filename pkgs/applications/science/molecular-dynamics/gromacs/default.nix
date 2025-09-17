{
  lib,
  stdenv,
  fetchurl,
  cmake,
  hwloc,
  fftw,
  perl,
  blas,
  lapack,
  llvmPackages,
  mpi,
  cudaPackages,
  plumed,
  singlePrec ? true,
  config,
  enableCuda ? config.cudaSupport,
  enableMpi ? false,
  enablePlumed ? false,
  cpuAcceleration ? null,
}:

# CUDA is only implemented for single precission
assert enableCuda -> singlePrec;

let
  inherit (cudaPackages.flags) cmakeCudaArchitecturesString;

  # Select reasonable defaults for all major platforms
  # The possible values are defined in CMakeLists.txt:
  # AUTO None SSE2 SSE4.1 AVX_128_FMA AVX_256 AVX2_256
  # AVX2_128 AVX_512 AVX_512_KNL MIC ARM_NEON ARM_NEON_ASIMD
  SIMD =
    x:
    if (cpuAcceleration != null) then
      x
    else if stdenv.hostPlatform.system == "i686-linux" then
      "SSE2"
    else if stdenv.hostPlatform.system == "x86_64-linux" then
      "SSE4.1"
    else if stdenv.hostPlatform.system == "x86_64-darwin" then
      "SSE4.1"
    else if stdenv.hostPlatform.system == "aarch64-linux" then
      "ARM_NEON_ASIMD"
    else
      "None";

  source =
    if enablePlumed then
      {
        version = "2024.2";
        hash = "sha256-gCp+M18uiVdw9XsVnk7DaOuw/yzm2sz3BsboAlw2hSs=";
      }
    else
      {
        version = "2025.3";
        hash = "sha256-i9/KAmjz8Qp8o8BuWbYvc+oCQgxnIRwP85EvMteDPGU=";
      };

in
stdenv.mkDerivation rec {
  pname = "gromacs";
  version = source.version;

  src = fetchurl {
    url = "ftp://ftp.gromacs.org/pub/gromacs/gromacs-${version}.tar.gz";
    inherit (source) hash;
  };

  patches = [ (if enablePlumed then ./pkgconfig-2024.patch else ./pkgconfig-2025.patch) ];

  postPatch = lib.optionalString enablePlumed ''
    plumed patch -p -e gromacs-${source.version}
  '';

  outputs = [
    "out"
    "dev"
    "man"
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optional enablePlumed plumed
  ++ lib.optionals enableCuda [ cudaPackages.cuda_nvcc ];

  buildInputs = [
    fftw
    perl
    hwloc
    blas
    lapack
  ]
  ++ lib.optional enableMpi mpi
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_cccl
    cudaPackages.cuda_cudart
    cudaPackages.libcufft
    cudaPackages.cuda_profiler_api
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin llvmPackages.openmp;

  propagatedBuildInputs = lib.optional enableMpi mpi;
  propagatedUserEnvPkgs = lib.optional enableMpi mpi;

  cmakeFlags = [
    (lib.cmakeBool "GMX_HWLOC" true)
    "-DGMX_SIMD:STRING=${SIMD cpuAcceleration}"
    "-DGMX_OPENMP:BOOL=TRUE"
    "-DBUILD_SHARED_LIBS=ON"
  ]
  ++ (
    if singlePrec then
      [
        "-DGMX_DOUBLE=OFF"
      ]
    else
      [
        "-DGMX_DOUBLE=ON"
        "-DGMX_DEFAULT_SUFFIX=OFF"
      ]
  )
  ++ (
    if enableMpi then
      [
        "-DGMX_MPI:BOOL=TRUE"
        "-DGMX_THREAD_MPI:BOOL=FALSE"
      ]
    else
      [
        "-DGMX_MPI:BOOL=FALSE"
      ]
  )
  ++ lib.optionals enableCuda [
    "-DGMX_GPU=CUDA"
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cmakeCudaArchitecturesString)

    # Gromacs seems to ignore and override the normal variables, so we add this ad hoc:
    (lib.cmakeFeature "GMX_CUDA_TARGET_COMPUTE" cmakeCudaArchitecturesString)
  ];

  postInstall = ''
    moveToOutput share/cmake $dev
  '';

  meta = with lib; {
    homepage = "https://www.gromacs.org";
    license = licenses.lgpl21Plus;
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

      See: https://www.gromacs.org/about.html for details.
    '';
    platforms = platforms.unix;
    maintainers = with maintainers; [
      sheepforce
      markuskowa
    ];
  };
}
