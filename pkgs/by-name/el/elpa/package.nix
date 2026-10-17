{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  mpiCheckPhaseHook,
  perl,
  python3,
  mpi,
  blas,
  lapack,
  scalapack,
  # CPU optimizations
  avxSupport ? stdenv.hostPlatform.avxSupport,
  avx2Support ? stdenv.hostPlatform.avx2Support,
  avx512Support ? stdenv.hostPlatform.avx512Support,
  config,
  # Enable NIVIA GPU support
  # Note, that this needs to be built on a system with a GPU
  # present for the tests to succeed.
  enableCuda ? config.cudaSupport,
  # type of GPU architecture
  nvidiaArch ? "sm_60",
  cudaPackages,
}:

assert blas.isILP64 == lapack.isILP64;
assert blas.isILP64 == scalapack.isILP64;

stdenv.mkDerivation (finalAttrs: {
  pname = "elpa";
  version = "2026.02.002";

  passthru = { inherit (blas) isILP64; };

  src = fetchurl {
    url = "https://elpa.mpcdf.mpg.de/software/tarball-archive/Releases/${finalAttrs.version}/elpa-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-AuPFn+xTzY62akzBX6T78ZDPllQiciP7itVXE+lCeTI=";
  };

  patches = [
    # Use a plain name for the pkg-config file
    ./pkg-config.patch

    # Several C-API functions with bind(C) were not declared as public in their
    # Fortran module, leading to link errors with gfortran 16.
    ./fix-c-api-visibility-gfortran16.patch
  ];

  postPatch = ''
    patchShebangs --build ./fdep/fortran_dependencies.pl

    # Fix the test script generator
    substituteInPlace Makefile.am --replace '#!/bin/bash' '#!${stdenv.shell}'
  ''
  + lib.optionalString enableCuda ''
    patchShebangs --build ./nvcc_wrap ./manual_cpp
  '';

  outputs = [
    "out"
    "doc"
    "man"
    "dev"
  ];

  nativeBuildInputs = [
    autoreconfHook
    perl
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_nvcc
    cudaPackages.libcusolver
    python3
  ];

  buildInputs = [
    mpi
    blas
    lapack
    scalapack
  ]
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
  ];

  env =
    let
      optFlags =
        lib.optionalString stdenv.hostPlatform.isx86_64 "-msse3 "
        + lib.optionalString avxSupport "-mavx "
        + lib.optionalString avx2Support "-mavx2 -mfma "
        + lib.optionalString avx512Support "-mavx512";
    in
    {
      FC = "mpifort";
      CC = "mpicc";
      CXX = "mpicxx";
      CPP = "cpp";
      FCFLAGS = optFlags;
      CFLAGS = optFlags;
    }
    # elpa's CUDA support pulls in a custom compiler wrapper
    # that does not distinguish gcc/g++
    // lib.optionalAttrs enableCuda { LDFLAGS = "-lstdc++"; };

  configureFlags = [
    "--with-mpi"
    "--without-threading-support-check-during-build"
  ]
  ++ lib.optional blas.isILP64 "--enable-64bit-integer-math-support"
  ++ lib.optional (!avxSupport) "--disable-avx"
  ++ lib.optional (!avx2Support) "--disable-avx2"
  ++ lib.optional (!avx512Support) "--disable-avx512"
  ++ lib.optional (!stdenv.hostPlatform.isx86_64) "--disable-sse"
  ++ lib.optional (!stdenv.hostPlatform.isx86_64) "--disable-sse-assembly"
  ++ lib.optional stdenv.hostPlatform.isx86_64 "--enable-sse-assembly"
  ++ lib.optional (!enableCuda) "--enable-openmp"
  ++ lib.optionals enableCuda [
    "--enable-nvidia-gpu"
    "--with-NVIDIA-GPU-compute-capability=${nvidiaArch}"
  ];

  enableParallelBuilding = true;

  doCheck = !enableCuda;

  nativeCheckInputs = [ mpiCheckPhaseHook ];
  preCheck = ''
    # Reduce test problem sizes
    export TEST_FLAGS="1500 50 16"
  '';

  meta = {
    description = "Eigenvalue Solvers for Petaflop-Applications";
    homepage = "https://elpa.mpcdf.mpg.de/";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.markuskowa ];
  };
})
