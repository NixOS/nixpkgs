{
  blas,
  cmake,
  config,
  cudaPackages,
  enableAccelerate ? false, # Use Accelerate on Darwin
  enableCuda ? config.cudaSupport,
  enableStatic ? stdenv.hostPlatform.isStatic,
  fetchFromGitHub,
  fixDarwinDylibNames,
  gfortran,
  gmp,
  lapack,
  lib,
  mpfr,
  ninja,
  llvmPackages,
  pkg-config,
  stdenv,
  writableTmpDirAsHomeHook,
}@inputs:

let
  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if enableCuda then cudaPackages.backendStdenv else inputs.stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "suitesparse";
  version = "7.14.0";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "DrTimothyAldenDavis";
    repo = "SuiteSparse";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7/rWHDcuBDegX+qTXPnA5HobZUx2hmCgVC+T98Kf4cI=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    # Needs to create directories as part of the build for the JIT
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals effectiveStdenv.cc.isGNU [
    # Per SuiteSparse, we can only use Fortran when it has the same compiler ID as the C/C++ compilers.
    gfortran
  ]
  ++ lib.optionals effectiveStdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  # CHOLMOD's CMake configuration calls find_dependency(CUDAToolkit).
  propagatedNativeBuildInputs = lib.optionals enableCuda [ cudaPackages.cuda_nvcc ];

  # Before CUDA 13, the runtime headers include CRT headers shipped with NVCC.
  propagatedBuildInputs = lib.optionals (enableCuda && cudaPackages.cudaOlder "13.0") [
    (lib.getInclude cudaPackages.cuda_nvcc)
  ];

  # CHOLMOD's public headers include cuBLAS and CUDA runtime headers.
  cudaPropagateToOutput = lib.optionalString enableCuda "dev";

  # Use compatible indexing for lapack and blas used
  buildInputs =
    assert (blas.isILP64 == lapack.isILP64);
    [
      blas
      lapack
      gmp
      mpfr
    ]
    ++ lib.optionals effectiveStdenv.cc.isClang [
      llvmPackages.openmp
    ]
    ++ lib.optionals enableCuda [
      cudaPackages.cccl
      cudaPackages.cuda_cudart
      cudaPackages.cuda_nvrtc
      cudaPackages.libcublas
    ];

  preConfigure = ''
    export GRAPHBLAS_CACHE_PATH="$(mktemp -d)"
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_STATIC_LIBS" enableStatic)
    (lib.cmakeBool "SUITESPARSE_DEMOS" false) # Demos aren't installed but could make interesting unit tests
    (lib.cmakeBool "SUITESPARSE_USE_STRICT" true)
    (lib.cmakeBool "SUITESPARSE_USE_PYTHON" false)
    (lib.cmakeBool "SUITESPARSE_USE_CUDA" enableCuda)
    (lib.cmakeBool "SUITESPARSE_USE_64BIT_BLAS" blas.isILP64)
    # The BLAS threading probes require a vendor even with explicit library paths.
    (lib.cmakeFeature "BLA_VENDOR" (if enableAccelerate then "Apple" else "Generic"))
    # CMake Warning at SuiteSparse_config/cmake_modules/SuiteSparsePolicy.cmake:328 (message):
    #   Warning: Using Fortran with SuiteSparse requires that it has the same
    #   compiler ID as the C/C++ compilers.  Use a compatible Fortran compiler, or
    #   set SUITESPARSE_USE_FORTRAN to OFF.
    (lib.cmakeBool "SUITESPARSE_USE_FORTRAN" effectiveStdenv.cc.isGNU)
  ]
  ++ lib.optionals (!enableAccelerate) [
    (lib.cmakeFeature "BLAS_LIBRARIES" "${lib.getLib blas}/lib/libblas${effectiveStdenv.hostPlatform.extensions.sharedLibrary}")
    (lib.cmakeFeature "LAPACK_LIBRARIES" "${lib.getLib lapack}/lib/liblapack${effectiveStdenv.hostPlatform.extensions.sharedLibrary}")
  ]
  ++ lib.optionals (effectiveStdenv.hostPlatform != effectiveStdenv.buildPlatform) [
    # GraphBLAS JIT builds a native helper binary (grb_jitpackage) but uses
    # the cross compiler, so it can't execute on the build host.
    (lib.cmakeBool "GRAPHBLAS_USE_JIT" false)
  ]
  ++ lib.optionals enableCuda [
    (lib.cmakeFeature "SUITESPARSE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
  ];

  # CMAKE build does not automatically provide doc output, so we make it ourselves
  postInstall = ''
    # Versions of SuiteSparse < 6 had a flat structure, which most downstream
    # consumers can continue to expect.
    for header in "$dev"/include/suitesparse/*; do
      ln -s "suitesparse/$(basename "$header")" "$dev/include/$(basename "$header")"
    done

    docdir=$doc/share/doc/${finalAttrs.pname}-${finalAttrs.version}
    mkdir -p $docdir

    # Top-level docs
    cp $src/LICENSE.txt $src/ChangeLog $src/README.md $docdir/

    # Per-component READMEs, licenses, and changelogs
    for f in $src/*/README.txt $src/*/README.md $src/*/LICENSE $src/*/LICENSE.txt $src/*/ChangeLog; do
      [ -f "$f" ] || continue
      component=$(basename $(dirname "$f"))
      cp "$f" "$docdir/''${component}_$(basename "$f")"
    done

    # User guides and papers from Doc directories
    for dir in $src/*/Doc; do
      [ -d "$dir" ] || continue
      component=$(basename $(dirname "$dir"))
      find "$dir" -name '*.pdf' -exec cp {} "$docdir/" \;
    done
  '';

  # The numerical tests can be flaky depending on the hardware and require further inspection before being enabled.
  doCheck = false;

  env = lib.optionalAttrs effectiveStdenv.hostPlatform.isDarwin {
    # Ensure that there is enough space for the `fixDarwinDylibNames` hook to
    # update the install names of the output dylibs.
    NIX_CFLAGS_LINK = "-headerpad_max_install_names";
  };

  meta = {
    homepage = "http://faculty.cse.tamu.edu/davis/suitesparse.html";
    description = "Suite of sparse matrix algorithms";
    license = with lib.licenses; [
      bsd2
      gpl2Plus
      lgpl21Plus
    ];
    maintainers = [ ];
    platforms = with lib.platforms; unix;
    problems = lib.optionalAttrs (enableAccelerate && !effectiveStdenv.hostPlatform.isDarwin) {
      broken.message = "Accelerate is only supported on Darwin.";
    };
  };
})
