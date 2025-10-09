{
  lib,
  config,
  fetchFromGitHub,
  stdenv,
  cmake,
  cudaPackages ? { },
  cudaSupport ? config.cudaSupport,
  pythonSupport ? true,
  python3Packages,
  llvmPackages,
  blas,
  swig,
  autoAddDriverRunpath,
  optLevel ?
    let
      optLevels =
        lib.optionals stdenv.hostPlatform.avx2Support [ "avx2" ]
        ++ lib.optionals stdenv.hostPlatform.sse4_1Support [ "sse4" ]
        ++ [ "generic" ];
    in
    # Choose the maximum available optimization level
    builtins.head optLevels,
}@inputs:

let
  pname = "faiss";
  version = "1.12.0";

  inherit (cudaPackages) flags backendStdenv;

  stdenv = if cudaSupport then backendStdenv else inputs.stdenv;

  cudaComponents = with cudaPackages; [
    cuda_cudart # cuda_runtime.h
    libcublas
    libcurand
    cuda_cccl

    # cuda_profiler_api.h
    (cudaPackages.cuda_profiler_api or cudaPackages.cuda_nvprof)
  ];
in
stdenv.mkDerivation {
  inherit pname version;

  outputs = [ "out" ] ++ lib.optionals pythonSupport [ "dist" ];

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "faiss";
    tag = "v${version}";
    hash = "sha256-VYryu70qu3JA0euPSD2xp2oJcACr7gXvssyZs1VBnSU=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
    autoAddDriverRunpath
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.python
    python3Packages.setuptools
    python3Packages.pip
  ];

  buildInputs = [
    blas
    swig
  ]
  ++ lib.optionals pythonSupport [ python3Packages.numpy ]
  ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ]
  ++ lib.optionals cudaSupport cudaComponents;

  cmakeFlags = [
    (lib.cmakeBool "FAISS_ENABLE_GPU" cudaSupport)
    (lib.cmakeBool "FAISS_ENABLE_PYTHON" pythonSupport)
    (lib.cmakeFeature "FAISS_OPT_LEVEL" optLevel)
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" flags.cmakeCudaArchitecturesString)
  ];

  buildFlags = [ "faiss" ] ++ lib.optionals pythonSupport [ "swigfaiss" ];

  # pip wheel->pip install commands copied over from opencv4

  postBuild = lib.optionalString pythonSupport ''
    (cd faiss/python &&
     python -m pip wheel --verbose --no-index --no-deps --no-clean --no-build-isolation --wheel-dir dist .)
  '';

  postInstall = lib.optionalString pythonSupport ''
    mkdir "$dist"
    cp faiss/python/dist/*.whl "$dist/"
  '';

  passthru = {
    inherit cudaSupport cudaPackages pythonSupport;
  };

  meta = {
    description = "Library for efficient similarity search and clustering of dense vectors by Facebook Research";
    mainProgram = "demo_ivfpq_indexing";
    homepage = "https://github.com/facebookresearch/faiss";
    changelog = "https://github.com/facebookresearch/faiss/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
