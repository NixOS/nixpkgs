{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  fetchpatch2,
  cmake,
  pkg-config,
  makeWrapper,
  bashNonInteractive,
  blas,
  lapack,
  zlib,
  mpi,
  mpiCheckPhaseHook,
  hypre,
  metis,
  parmetis,
  mfem,
  libceed,
  petsc,
  slepc,
  nlohmann_json,
  nlohmann_json_schema_validator,
  fmt,
  scnlib,
  eigen_5,
  catch2_3,
  coreutils,
  findutils,
  gnugrep,
  which,

  withGslib ? true,
  # ParMETIS is unfree in nixpkgs. Palace links it only when SuperLU_DIST does.
  withParmetis ? false,
}:

let
  # Palace solves complex-valued problems through PETSc/SLEPc, so both must be
  # built with complex scalars. PETSc's hypre support is real-only, and Palace
  # uses hypre directly (through MFEM) rather than through PETSc, so build a
  # minimal PETSc like Palace's own superbuild does.
  petsc' = petsc.override {
    scalarType = "complex";
    withCommonDeps = false;
    fortranSupport = false;
  };
  slepc' = slepc.override {
    petsc = petsc';
    withArpack = false;
  };

  # Upstream MFEM patches Palace applies on top of MFEM 4.10 (from
  # cmake/ExternalMFEM.cmake and spack_repo/local/packages/palace/package.py).
  mfemPatch =
    name: url: hash:
    fetchpatch2 {
      name = "mfem-${name}.patch";
      url = "${url}?full_index=1";
      # Upstream commits also edit MFEM's CHANGELOG, which differs from the release.
      excludes = [ "CHANGELOG" ];
      inherit hash;
    };
  mfemPatches = [
    # https://github.com/mfem/mfem/pull/3847
    (mfemPatch "pr3847"
      "https://github.com/mfem/mfem/compare/2d574015756711029556c14d096ca52c15d5b663...50ead1a9a785e3273b2a72ff59ac8ed8a496b498.diff"
      "sha256-jalubEy4ouGDcPWShU874/tCSiWX7RJ89/4s+jTuOrQ="
    )
    # https://github.com/mfem/mfem/pull/5353
    (fetchurl {
      url = "https://raw.githubusercontent.com/awslabs/palace/b22f654ab36fe01f1f3176349c60626efed1a6a2/extern/patch/mfem/mfem_pr5353.diff";
      hash = "sha256-w19YQJD5fITBL8gObVwGhRKRHRkhMuGPWqQlT1B8Xk8=";
    })
    # https://github.com/mfem/mfem/pull/5494: non-conforming mesh partitioning fixes
    (mfemPatch "pr5494"
      "https://github.com/mfem/mfem/compare/10b0b596dbc26dca384b9f25f23026b1a6403592...399d72c2b7607e25d196dc19fd70b8840eaf1cc8.diff"
      "sha256-X7ikXb4KojDxbNfyv3HPWZ9nJBkylLoO4YeRLrNyyoI="
    )
    # https://github.com/mfem/mfem/pull/5502
    (mfemPatch "pr5502"
      "https://github.com/mfem/mfem/commit/3091ba40b238c4008b67216314bb26da6738b833.diff"
      "sha256-uNI4JoaBr48s40iY0LfTC2SkepeV8PkOnG9tBvlWnpU="
    )
    # https://github.com/mfem/mfem/pull/5531
    (mfemPatch "pr5531"
      "https://github.com/mfem/mfem/commit/641e56439e63a1774f43bc2ba904797694a047ad.diff"
      "sha256-Qy1LqFOq57v4+SK0huu8OE9IGReDrp9JSvujVbnxqMc="
    )
    # https://github.com/mfem/mfem/pull/5639
    (mfemPatch "pr5639"
      "https://github.com/mfem/mfem/commit/864d476acf25135d2059d3379d208e635823f26c.diff"
      "sha256-ynQuB/qAqHpX4KIpovLTsb2DamZXtSkKA8gNwtKhDQI="
    )
    # https://github.com/mfem/mfem/pull/5698
    (mfemPatch "pr5698"
      "https://github.com/mfem/mfem/commit/e38d2e051b05ba10e27eeb96dfc556ce6424c649.diff"
      "sha256-dBKqPvFY7TyIU8+lPREzMc+8i9kQY/aPG9+XI+dgw9M="
    )
    # https://github.com/mfem/mfem/pull/5610
    (mfemPatch "pr5610"
      "https://github.com/mfem/mfem/commit/e9247694fb4e8e433df3ce24c4aaa3c5d5487c91.diff"
      "sha256-haUQ1Vq5RPNEmSil+z6Irlqm5MptJD/TR+8Aio/ZaB4="
    )
    # https://github.com/mfem/mfem/pull/5714
    (mfemPatch "pr5714"
      "https://github.com/mfem/mfem/commit/c09fb9b6c1178afaae083aa19448a9b4abc3c35f.diff"
      "sha256-bjJ35+eV+wIe22lljb4t+BSL8eqXrsBatFbdnITh9qw="
    )
  ];

  mfem' =
    (mfem.override {
      inherit withGslib withParmetis;
      withSuperLU = true;
    }).overrideAttrs
      (old: {
        pname = "mfem-palace";
        patches = (old.patches or [ ]) ++ mfemPatches;
      });
in
stdenv.mkDerivation (finalAttrs: {
  pname = "palace";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "awslabs";
    repo = "palace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SyO29hRs8kQFOFTe5Aav6qHExuE6/TwBTJdGCHPtCFQ=";
  };

  patches = [
    # Palace never calls ParMETIS itself; let it build without it.
    ./optional-parmetis.patch
  ];

  # The top-level CMakeLists.txt is a superbuild that downloads and builds all
  # dependencies. Build the Palace project directly instead (as Spack does);
  # it still uses ../cmake, ../scripts and ../test from the source tree.
  cmakeDir = "../palace";

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
    mpi
  ];

  buildInputs = [
    # for patchShebangs on the `palace` launcher script
    bashNonInteractive
    blas
    lapack
    zlib
    mpi
    hypre
    metis
    mfem'
    mfem'.superlu_dist
    libceed
    petsc'
    slepc'
    nlohmann_json
    nlohmann_json_schema_validator
    fmt
    scnlib
    eigen_5
  ]
  ++ lib.optional withGslib mfem'.gslib
  ++ lib.optional withParmetis parmetis;

  checkInputs = [ catch2_3 ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" (!stdenv.hostPlatform.isStatic))
    # Only affects whether test/unit fetches Catch2 or uses find_package.
    (lib.cmakeBool "PALACE_BUILD_EXTERNAL_DEPS" false)
    # Printed by `palace --version`; defaults to `git describe`.
    (lib.cmakeFeature "PALACE_GIT_COMMIT_ID" finalAttrs.src.tag)
    (lib.cmakeBool "PALACE_WITH_OPENMP" false)
    (lib.cmakeBool "PALACE_WITH_CUDA" false)
    (lib.cmakeBool "PALACE_WITH_HIP" false)
    (lib.cmakeBool "PALACE_WITH_SUPERLU" true)
    (lib.cmakeBool "PALACE_WITH_STRUMPACK" false)
    (lib.cmakeBool "PALACE_WITH_MUMPS" false)
    (lib.cmakeBool "PALACE_WITH_SLEPC" true)
    (lib.cmakeBool "PALACE_WITH_ARPACK" false)
    # Requires SUNDIALS built with MPI (nvecparallel), which nixpkgs lacks.
    (lib.cmakeBool "PALACE_WITH_SUNDIALS" false)
    (lib.cmakeBool "PALACE_WITH_GSLIB" withGslib)
    (lib.cmakeFeature "PETSC_DIR" "${petsc'}")
    (lib.cmakeFeature "SLEPC_DIR" "${slepc'}")
    (lib.cmakeFeature "LIBCEED_DIR" "${libceed}")
  ];

  enableParallelBuilding = true;

  postInstall = ''
    # The `palace` launcher script locates palace-<arch>.bin next to itself and
    # starts it with mpirun.
    wrapProgram $out/bin/palace \
      --prefix PATH : ${
        lib.makeBinPath [
          mpi
          coreutils
          findutils
          gnugrep
          which
        ]
      }
  '';

  # Unit tests take a long time to build; keep a quick smoke test instead.
  doInstallCheck = true;
  nativeInstallCheckInputs = [ mpiCheckPhaseHook ];
  __darwinAllowLocalNetworking = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/palace --version | grep -F "${finalAttrs.src.tag}"
    $out/bin/palace --help > /dev/null

    runHook postInstallCheck
  '';

  passthru = {
    mfem = mfem';
    petsc = petsc';
    slepc = slepc';
  };

  meta = {
    description = "3D finite element solver for computational electromagnetics";
    longDescription = ''
      Palace (PArallel LArge-scale Computational Electromagnetics) is a
      parallel finite element code for full-wave 3D electromagnetic
      simulations: eigenmode, frequency-domain driven, transient,
      electrostatic and magnetostatic analysis, used in particular for
      superconducting quantum device design.
    '';
    homepage = "https://awslabs.github.io/palace/";
    changelog = "https://github.com/awslabs/palace/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ grahamnorris ];
    mainProgram = "palace";
    platforms = lib.platforms.unix;
  };
})
