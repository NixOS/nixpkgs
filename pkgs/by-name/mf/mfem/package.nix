{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  blas,
  lapack,
  zlib,
  mpi,
  hypre,
  metis,
  parmetis,
  superlu_dist,
  gslib,
  mpiCheckPhaseHook,
  llvmPackages,

  mpiSupport ? true,
  withLapack ? true,
  withSuperLU ? mpiSupport,
  withGslib ? mpiSupport,
  # ParMETIS is unfree in nixpkgs; it is only used through SuperLU_DIST here.
  withParmetis ? false,
  withOpenmp ? false,
  withExceptions ? false,
}:

assert withSuperLU -> mpiSupport;
assert withParmetis -> withSuperLU;

let
  superlu_dist' = superlu_dist.override { inherit withParmetis; };
  gslib' = gslib.override { inherit mpiSupport; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mfem";
  version = "4.10";

  src = fetchFromGitHub {
    owner = "mfem";
    repo = "mfem";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RMGkoqD6Y9a8ssSxXXlfhWbG/wUZp4t7IQrchpnBwFw=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # FindMPI needs the mpicxx wrapper
  nativeBuildInputs = [ cmake ] ++ lib.optional mpiSupport mpi;

  buildInputs = [
    zlib
  ]
  ++ lib.optionals withLapack [
    blas
    lapack
  ]
  ++ lib.optional withSuperLU superlu_dist'
  ++ lib.optional withParmetis parmetis
  ++ lib.optional withGslib gslib'
  ++ lib.optional (withOpenmp && stdenv.cc.isClang) llvmPackages.openmp;

  # MFEMConfig.cmake re-exports these to consumers
  propagatedBuildInputs = lib.optionals mpiSupport [
    mpi
    hypre
    metis
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    (lib.cmakeBool "MFEM_USE_MPI" mpiSupport)
    (lib.cmakeBool "MFEM_USE_METIS" mpiSupport)
    (lib.cmakeBool "MFEM_USE_ZLIB" true)
    (lib.cmakeBool "MFEM_USE_LAPACK" withLapack)
    (lib.cmakeBool "MFEM_USE_SUPERLU" withSuperLU)
    (lib.cmakeBool "MFEM_USE_GSLIB" withGslib)
    (lib.cmakeBool "MFEM_USE_OPENMP" withOpenmp)
    (lib.cmakeBool "MFEM_THREAD_SAFE" withOpenmp)
    (lib.cmakeBool "MFEM_USE_EXCEPTIONS" withExceptions)
    (lib.cmakeBool "MFEM_ENABLE_TESTING" false)
    (lib.cmakeBool "MFEM_ENABLE_EXAMPLES" false)
    (lib.cmakeBool "MFEM_ENABLE_MINIAPPS" false)
  ]
  ++ lib.optionals withSuperLU [
    # The MFEM default also requires ParMETIS, which nixpkgs' superlu_dist
    # only links when built withParmetis.
    (lib.cmakeFeature "SuperLUDist_REQUIRED_PACKAGES" (
      lib.concatStringsSep ";" ([ "MPI" ] ++ lib.optional withParmetis "ParMETIS" ++ [ "METIS" ])
    ))
  ];

  enableParallelBuilding = true;

  # Smoke test: build and run the serial and parallel versions of example 1
  # against the build tree.
  doCheck = true;
  nativeCheckInputs = lib.optional mpiSupport mpiCheckPhaseHook;
  __darwinAllowLocalNetworking = mpiSupport;
  checkPhase = ''
    runHook preCheck

    make -j$NIX_BUILD_CORES ex1 ${lib.optionalString mpiSupport "ex1p"}
    (cd examples && ./ex1 -m ../../data/star.mesh -no-vis)
  ''
  + lib.optionalString mpiSupport ''
    (cd examples && mpiexec -n 2 ./ex1p -m ../../data/star.mesh -no-vis)
  ''
  + ''
    # Building an example copies the mesh data to build/data and `make install`
    # would then install it to $out/data. Keep the output independent of doCheck.
    rm -rf data

    runHook postCheck
  '';

  passthru = {
    inherit mpiSupport withSuperLU withGslib;
    superlu_dist = superlu_dist';
    gslib = gslib';
  };

  meta = {
    description = "Lightweight, general, scalable C++ library for finite element methods";
    homepage = "https://mfem.org";
    changelog = "https://github.com/mfem/mfem/blob/${finalAttrs.src.tag}/CHANGELOG";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ grahamnorris ];
    platforms = lib.platforms.unix;
  };
})
