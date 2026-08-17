{
  lib,
  fetchFromGitHub,
  fetchurl,
  fetchpatch,
  nix-update-script,
  cmake,
  boost,
  ceres-solver,
  eigen,
  openimageio,
  glog,
  libGLU,
  glew,
  flann,
  cgal,
  gmp,
  mpfr,
  suitesparse,
  onnxruntime,
  poselib,
  lz4,
  autoAddDriverRunpath,
  config,
  stdenv,
  qt5,
  libsm,
  cudaSupport ? config.cudaSupport,
  cudaCapabilities ? cudaPackages.flags.cudaCapabilities,
  cudaPackages,
  faiss,
  sqlite,
  llvmPackages,
  gtest,
  curl,

  enableTests ? true,
}:

assert cudaSupport -> cudaPackages != { };

let
  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;

  depsAlsoForPycolmap = [
    boost
    eigen
    ceres-solver
    openimageio
    glog
    libGLU
    glew
    cgal
    poselib
    faiss
    sqlite
    gmp
    mpfr
    lz4
    qt5.qtbase
    suitesparse
    onnxruntime
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart # CUDA::cudart, used by COLMAP and faiss
    cudaPackages.libcublas # CUDA::cublas, propagated by faiss' exported targets
    cudaPackages.libcurand # CUDA::curand, used by COLMAP
  ]
  ++ lib.optional stdenv'.cc.isClang llvmPackages.openmp;

  # COLMAP needs these model files to run the ONNX tests
  # Based on: https://github.com/colmap/colmap/blob/79efc74b2b614935a3c69b1f983f2bad23a836a1/src/colmap/feature/resources.h#L36
  modelsForTesting = [
    {
      name = "aliked-n16rot.onnx";
      url = "https://github.com/colmap/colmap/releases/download/3.13.0/aliked-n16rot.onnx";
      sha256 = "39c423d0a6f03d39ec89d3d1d61853765c2fb6a8b8381376c703e5758778a547";
    }
    {
      name = "aliked-n32.onnx";
      url = "https://github.com/colmap/colmap/releases/download/3.13.0/aliked-n32.onnx";
      sha256 = "a077728a02d2de1a775c66df6de8cfeb7c6b51ca57572c64c680131c988c8b3c";
    }
    {
      name = "aliked-lightglue.onnx";
      url = "https://github.com/colmap/colmap/releases/download/3.13.0/aliked-lightglue.onnx";
      sha256 = "b9a5de7204648b18a8cf5dcac819f9d30de1a5961ef03756803c8b86c2dceb8d";
    }
    {
      name = "bruteforce-matcher.onnx";
      url = "https://github.com/colmap/colmap/releases/download/3.13.0/bruteforce-matcher.onnx";
      sha256 = "3c1282f96d83f5ffc861a873298d08bbe5219f59af59223f5ceab5c41a182a47";
    }
    {
      name = "sift-lightglue.onnx";
      url = "https://github.com/colmap/colmap/releases/download/3.13.0/sift-lightglue.onnx";
      sha256 = "e0500228472b43f92b3d36881a09b3310d3b058b56187b246cc7b9ab6429096e";
    }
  ];
in
stdenv'.mkDerivation (finalAttrs: {
  version = "4.0.4";
  pname = "colmap";
  src = fetchFromGitHub {
    owner = "colmap";
    repo = "colmap";
    tag = finalAttrs.version;
    hash = "sha256-n9YwEqMSIh6vM2MVf7qxxVvDpsTLEsT37xoHiX66bL0=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  patches =
    lib.optionals stdenv'.hostPlatform.isAarch64 [
      # Set SANITIZE_PR for PoissonRecon to fix data races on aarch64
      # https://github.com/colmap/colmap/pull/4429
      (fetchpatch {
        url = "https://github.com/colmap/colmap/commit/e13294e43baae6cf7f4e3ec05a19060e0b230a72.patch";
        hash = "sha256-hoIjWdrOlXeT78X+g3YCDWaWnmQMzHVQNkdpx5vXpGk=";
      })
      (fetchpatch {
        url = "https://github.com/colmap/colmap/commit/6c5c59f96f9e819bcc57267ef48b193d77707fe0.patch";
        hash = "sha256-2dAhy3sgxF2SXPAYE/EV1hd61dm05vJ5JJXEjQxEKWM=";
      })
    ]
    ++ lib.optionals (stdenv'.hostPlatform.isLinux && stdenv'.hostPlatform.isAarch64) [
      # Fix determinism check in rotation_averaging_test
      # https://github.com/colmap/colmap/pull/4426
      (fetchpatch {
        url = "https://github.com/colmap/colmap/commit/d38b65b9312c66e841739989f4a38924d8cb5ec5.patch";
        hash = "sha256-dbs+TNfa4o5L79+krPpF4VmP8PhFHtzYZehYZbsnx5s=";
      })
    ];

  cmakeFlags = [
    (lib.cmakeBool "DOWNLOAD_ENABLED" true) # We want COLMAP to be able to fetch models like LightGlue.
    (lib.cmakeBool "UNINSTALL_ENABLED" false)
    (lib.cmakeBool "FETCH_POSELIB" false)
    (lib.cmakeBool "FETCH_FAISS" false)
    (lib.cmakeBool "FETCH_ONNX" false)
    (lib.cmakeBool "TESTS_ENABLED" enableTests)
    (lib.cmakeFeature "CHOLMOD_INCLUDE_DIR_HINTS" "${lib.getDev suitesparse}/include")
    (lib.cmakeFeature "CHOLMOD_LIBRARY_DIR_HINTS" "${lib.getLib suitesparse}/lib")
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeBool "CUDA_ENABLED" cudaSupport)
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" (
      lib.strings.concatStringsSep ";" (map cudaPackages.flags.dropDots cudaCapabilities)
    ))
  ];

  buildInputs = [
    boost
    ceres-solver
    eigen
    openimageio
    glog
    libGLU
    glew
    gtest
    qt5.qtbase
    flann
    lz4
    cgal
    gmp
    mpfr
    libsm
    curl
  ]
  ++ depsAlsoForPycolmap;

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
    gtest
  ]
  ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
  ];

  doCheck = enableTests;
  preCheck = lib.optionalString enableTests (
    let
      disabledTestPatterns = [
        # Disable any test involving OpenGL or GPU, these won't work in the sandbox.
        "*Gpu*"
        "*GPU*"
        "*OpenGL*"
      ]
      ++ lib.optionals stdenv'.hostPlatform.isDarwin [
        # reconstruction_pruning_test.cc:65: Failure
        # Expected: (redundant_point3D_ids.size()) > (prev_num_redundant_points3D), actual: 0 vs 0
        "FindRedundantPoints3D.VaryingCoverageGain"
      ];
    in
    ''
      export GTEST_FILTER='-${lib.concatStringsSep ":" disabledTestPatterns}'
    ''
    + ''
      export HOME=$PWD
    ''
    # Pre-fetch the ONNX models into COLMAP's cache dir so we can run their tests.
    + ''
      mkdir -p .cache/colmap
      ${lib.concatMapStringsSep "\n" (model: ''
        ln -s ${fetchurl model} .cache/colmap/${model.sha256}-${model.name}
      '') modelsForTesting}
    ''
  );

  passthru = {
    depsAlsoForPycolmap = depsAlsoForPycolmap;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Structure-From-Motion and Multi-View Stereo pipeline";
    longDescription = ''
      COLMAP is a general-purpose Structure-from-Motion (SfM) and Multi-View Stereo (MVS) pipeline
      with a graphical and command-line interface.
    '';
    mainProgram = "colmap";
    homepage = "https://colmap.github.io/index.html";
    downloadPage = "https://github.com/colmap/colmap";
    changelog = "https://github.com/colmap/colmap/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    platforms = if cudaSupport then lib.platforms.linux else lib.platforms.unix;
    maintainers = with lib.maintainers; [
      lebastr
      usertam
      chpatrick
    ];
  };
})
