{
  lib,
  boost,
  ceres-solver,
  cgal,
  cmake,
  config,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
  eigen,
  fetchFromGitHub,
  glfw,
  gmp,
  libjxl,
  libjpeg,
  libpng,
  libtiff,
  mpfr,
  nanoflann,
  nix-update-script,
  llvmPackages,
  opencv,
  pkg-config,
  python3Packages,
  stdenv,
  vcg,
  zstd,
}:

let
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;

  boostWithZstd = boost.overrideAttrs (old: {
    buildInputs = old.buildInputs ++ [ zstd ];
  });
in
effectiveStdenv.mkDerivation (finalAttrs: {
  version = "2.4.0";
  pname = "openmvs";

  src = fetchFromGitHub {
    owner = "cdcseacave";
    repo = "openmvs";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-0tL2tqHYBQMGL9k+NqTUxieWuDP3YB6X9DcXYnlGWWg=";
  };

  patches = [
    # Without a GPU, logging a CUDA error dereferences uninitialized strings and crashes instead of
    # falling back to the CPU.
    # https://github.com/cdcseacave/openMVS/pull/1316
    ./report-cuda-error-uninit.patch
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'FIND_PACKAGE(Boost REQUIRED COMPONENTS iostreams program_options system serialization OPTIONAL_COMPONENTS ''${Boost_EXTRA_COMPONENTS})' \
        'FIND_PACKAGE(Boost REQUIRED COMPONENTS iostreams program_options serialization OPTIONAL_COMPONENTS ''${Boost_EXTRA_COMPONENTS})'
  ''
  # pyOpenMVS hardcodes CUDA architectures (including ones CUDA 13 no longer supports) instead of
  # using CMAKE_CUDA_ARCHITECTURES. Removed upstream in
  # https://github.com/cdcseacave/openMVS/commit/b2f21a032376 (after v2.4.0).
  + lib.optionalString cudaSupport ''
    substituteInPlace libs/MVS/CMakeLists.txt \
      --replace-fail \
        'SET_TARGET_PROPERTIES(pyOpenMVS PROPERTIES CUDA_ARCHITECTURES "50;72;75")' \
        ""
  '';

  cmakeFlags = [
    (lib.cmakeFeature "Python3_EXECUTABLE" (lib.getExe python3Packages.python))
    # Upstream enables CUDA whenever nvcc is found (e.g. when propagated by OpenCV or Ceres);
    # make it follow cudaSupport instead.
    (lib.cmakeBool "OpenMVS_USE_CUDA" cudaSupport)
  ]
  ++ lib.optionals cudaSupport [
    # Upstream defaults to "native", which requires a GPU at build time.
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
  ]
  # SSE is enabled by default
  ++ lib.optionals (!stdenv.hostPlatform.isx86_64) [
    (lib.cmakeBool "OpenMVS_USE_SSE" false)
  ];

  buildInputs = [
    boostWithZstd
    ceres-solver
    cgal
    eigen
    glfw
    gmp
    libjxl
    libjpeg
    libpng
    libtiff
    mpfr
    nanoflann
    opencv
    llvmPackages.openmp
    vcg
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart # CUDA::cudart and CUDA::cuda_driver
    cudaPackages.libcurand # CUDA::curand
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.python
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  postInstall = ''
    mv $out/bin/OpenMVS/* $out/bin
    rmdir $out/bin/OpenMVS
    rm $out/bin/Tests
  '';

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    ${lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) ''
      export KMP_AFFINITY=disabled
      export OMP_PROC_BIND=false
    ''}
    ctest --output-on-failure
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open Multi-View Stereo reconstruction library";
    homepage = "https://github.com/cdcseacave/openMVS";
    changelog = "https://github.com/cdcseacave/openMVS/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    platforms = if cudaSupport then lib.platforms.linux else lib.platforms.unix;
    maintainers = with lib.maintainers; [
      bouk
      miniharinn
    ];
  };
})
