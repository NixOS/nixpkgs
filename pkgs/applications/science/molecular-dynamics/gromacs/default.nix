{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
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

# CUDA is only implemented for single precision
assert enableCuda -> singlePrec;

let
  inherit (cudaPackages.flags) cmakeCudaArchitecturesString;

  effectiveStdenv = if enableCuda then cudaPackages.backendStdenv else stdenv;
  inherit (effectiveStdenv) hostPlatform;

  # Select reasonable defaults for all major platforms
  # The possible values are defined in CMakeLists.txt:
  # AUTO None SSE2 SSE4.1 AVX_128_FMA AVX_256 AVX2_256
  # AVX2_128 AVX_512 AVX_512_KNL MIC ARM_NEON ARM_NEON_ASIMD
  SIMD =
    x:
    if (cpuAcceleration != null) then
      x
    else if hostPlatform.system == "i686-linux" then
      "SSE2"
    else if hostPlatform.system == "x86_64-linux" then
      "SSE4.1"
    else if hostPlatform.system == "x86_64-darwin" then
      "SSE4.1"
    else if hostPlatform.system == "aarch64-darwin" then
      "ARM_NEON_ASIMD"
    else if hostPlatform.system == "aarch64-linux" then
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
        version = "2026.2";
        hash = "sha256-0n5EVegkYXeVI2Z5hjGg2tny4fVnQApsuFShaNzAUN0=";
      };

in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "gromacs";
  version = source.version;

  src = fetchurl {
    url = "ftp://ftp.gromacs.org/pub/gromacs/gromacs-${finalAttrs.version}.tar.gz";
    inherit (source) hash;
  };

  patches = [
    # Fix pkg-config paths for the version-specific gromacs variant.
    (if enablePlumed then ./pkgconfig-2024.patch else ./pkgconfig-2025.patch)
  ]
  ++ lib.optionals enablePlumed [
    # Backport gcc 15 cstdint include fix.
    (fetchpatch2 {
      url = "https://gitlab.com/gromacs/gromacs/-/commit/e0180bc37f3111d7dcaffca3854c088ed910c3b4.diff";
      hash = "sha256-TvTzfb/RETAzFpYfFFr6/L5GV1Pile16gVJhNigwAB4=";
    })
  ];

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
  ++ lib.optionals enablePlumed [ plumed ]
  ++ lib.optionals enableCuda [ cudaPackages.cuda_nvcc ];

  buildInputs = [
    fftw
    perl
    hwloc
    blas
    lapack
  ]
  ++ lib.optionals enableMpi [ mpi ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_cccl
    cudaPackages.cuda_cudart
    cudaPackages.libcufft
    cudaPackages.cuda_profiler_api
  ]
  ++ lib.optionals hostPlatform.isDarwin [ llvmPackages.openmp ];

  propagatedBuildInputs = lib.optionals enableMpi [ mpi ];
  propagatedUserEnvPkgs = lib.optionals enableMpi [ mpi ];

  cmakeFlags = [
    (lib.cmakeBool "GMX_HWLOC" true)
    (lib.cmakeFeature "GMX_SIMD" (SIMD cpuAcceleration))
    (lib.cmakeBool "GMX_OPENMP" true)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)

    (lib.cmakeBool "GMX_DOUBLE" (!singlePrec))
    (lib.cmakeBool "GMX_DEFAULT_SUFFIX" singlePrec)

    (lib.cmakeBool "GMX_MPI" enableMpi)
  ]
  ++ lib.optionals enableMpi [
    (lib.cmakeBool "GMX_THREAD_MPI" false)
  ]
  ++ lib.optionals enableCuda [
    (lib.cmakeFeature "GMX_GPU" "CUDA")
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cmakeCudaArchitecturesString)

    # Gromacs seems to ignore and override the normal variables, so we add this ad hoc:
    (lib.cmakeFeature "GMX_CUDA_TARGET_COMPUTE" cmakeCudaArchitecturesString)
  ];

  postInstall = ''
    moveToOutput share/cmake $dev
  '';

  meta = {
    homepage = "https://www.gromacs.org";
    license = lib.licenses.lgpl21Plus;
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
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      sheepforce
      markuskowa
    ];
  };
})
