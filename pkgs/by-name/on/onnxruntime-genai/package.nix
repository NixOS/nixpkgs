{ config
, stdenv
, lib
, fetchFromGitHub
, Foundation
, abseil-cpp
, cmake
, eigen
, gtest
, libpng
, nlohmann_json
, nsync
, pkg-config
, python3Packages
, re2
, zlib
, microsoft-gsl
, iconv
, protobuf_21
, pythonSupport ? true
, cudaSupport ? config.cudaSupport
, cudaPackages ? {}
, onnxruntime
, buildEnv
, simdjson
}@inputs:


let
  version = "0.2.0-rc4";

  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else inputs.stdenv;

  cudaCapabilities = cudaPackages.cudaFlags.cudaCapabilities;
  # E.g. [ "80" "86" "90" ]
  cudaArchitectures = (builtins.map cudaPackages.cudaFlags.dropDot cudaCapabilities);
  cudaArchitecturesString = lib.strings.concatStringsSep ";" cudaArchitectures;

  ort = buildEnv { name = "ort"; paths = [  onnxruntime  onnxruntime.dev ]; };
in
effectiveStdenv.mkDerivation rec {
  pname = "onnxruntime-genai";
  inherit version;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxruntime-genai";
    rev = "refs/tags/v${version}";
    hash = "sha256-BTVJSa4ltcy9sURQ/Q2ou9h3bLphh01va9bogoobxAs=";
  };

  patches = [
    # If you stumble on these patches trying to update onnxruntime, check
    # `git blame` and ping the introducers.

    # Context: we want the upstream to
    # - during nix build target directory doesn't have write permissions, so we do these actions in postBuild phase
    ./0001-dont-copy-files-into-wheel.patch
  ] ++ lib.optionals cudaSupport [
    # This patch is copied from onnxruntime main package
    # We apply the referenced 1064.patch ourselves to our nix dependency.
    #  FIND_PACKAGE_ARGS for CUDA was added in https://github.com/microsoft/onnxruntime/commit/87744e5 so it might be possible to delete this patch after upgrading to 1.17.0
    # ./nvcc-gsl.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.python
    protobuf_21
    ort
    simdjson
  ] ++ lib.optionals pythonSupport (with python3Packages; [
    pip
    python
    pythonOutputDistHook
    setuptools
    wheel
    python3Packages.onnxruntime
  ]) ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    eigen
    libpng
    zlib
    nlohmann_json
    microsoft-gsl
    ort
  ] ++ lib.optionals pythonSupport (with python3Packages; [
    numpy
    pybind11
    packaging
  ]) ++ lib.optionals effectiveStdenv.isDarwin [
    Foundation
    iconv
  ] ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_cccl # cub/cub.cuh
    libcublas # cublas_v2.h
    libcurand # curand.h
    libcusparse # cusparse.h
    libcufft # cufft.h
    cudnn # cudnn.h
    cuda_cudart
  ]);

  nativeCheckInputs = [
    gtest
  ] ++ lib.optionals pythonSupport (with python3Packages; [
    pytest
    sympy
    onnx
  ]);

  # Python's wheel is stored in a separate dist output
  outputs = [ "out" ] ++ lib.optionals pythonSupport [ "dist" ];

  enableParallelBuilding = true;

  cmakeDir = "cmake";

  cmakeFlags = [
    "-S .."
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DFETCHCONTENT_QUIET=OFF"
    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
    "-DBUILD_WHEEL=${if pythonSupport then "ON" else "OFF"}"
    "-DUSE_DML=OFF"
    "-DORT_HOME=${ort}"
    (lib.cmakeBool "USE_CUDA" cudaSupport)
    "-DFETCHCONTENT_SOURCE_DIR_SIMDJSON=${simdjson.src}"
    "-DFETCHCONTENT_SOURCE_DIR_GSL=${microsoft-gsl.src}"
    "-DFETCHCONTENT_SOURCE_DIR_GOOGLETEST=${gtest.src}"
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeFeature "onnxruntime_CUDNN_HOME" "${cudaPackages.cudnn}")
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaArchitecturesString)
    (lib.cmakeFeature "onnxruntime_NVCC_THREADS" "1")
    "-DCUDA_HOME=${cudaPackages.cuda_nvcc}"
    (lib.cmakeFeature "CMAKE_CUDA_COMPILER" "${cudaPackages.cuda_nvcc}/bin/nvcc")

  ];

  env = lib.optionalAttrs effectiveStdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=deprecated-declarations"
      "-Wno-error=unused-but-set-variable"
    ];
  };

  doCheck = !cudaSupport;

  requiredSystemFeatures = lib.optionals cudaSupport [ "big-parallel" ];

  postPatch = lib.optionalString (!cudaSupport) ''
    substituteInPlace cmake/options.cmake \
      --replace-fail  'option(USE_CUDA "Build with CUDA support" ON)' 'option(USE_CUDA "Build with CUDA support" OFF)'
  '' + lib.optionalString (!pythonSupport) ''
    substituteInPlace cmake/options.cmake \
      --replace-fail  'option(ENABLE_PYTHON "Build the Python API." ON)' 'option(ENABLE_PYTHON "Build the Python API." OFF)'
  '';

  postBuild = lib.optionalString pythonSupport ''
    cd wheel
    chmod +w onnxruntime_genai
    cp ../src/python/onnxruntime_genai.cpython-311-x86_64-linux-gnu.so onnxruntime_genai/
    cp $src/ThirdPartyNotices.txt onnxruntime_genai/
    ${python3Packages.python.interpreter} setup.py bdist_wheel
    cd ..
  '';

  postInstall = ''
    pwd
    mkdir -p $out/lib
    cp libonnxruntime-genai.so $out/lib/
    mkdir -p dist
    cp -r wheel/dist/. dist/
  '';

  passthru = {
    inherit cudaSupport cudaPackages onnxruntime; # for the python module
    protobuf = protobuf_21;
    tests = lib.optionalAttrs pythonSupport {
      python = python3Packages.onnxruntime-genai;
    };
  };

  meta = with lib; {
    description = "Cross-platform, high performance scoring engine for ML models";
    longDescription = ''
      ONNX Runtime is a performance-focused complete scoring engine
      for Open Neural Network Exchange (ONNX) models, with an open
      extensible architecture to continually address the latest developments
      in AI and Deep Learning. ONNX Runtime stays up to date with the ONNX
      standard with complete implementation of all ONNX operators, and
      supports all ONNX releases (1.2+) with both future and backwards
      compatibility.
    '';
    homepage = "https://github.com/microsoft/onnxruntime-genai";
    changelog = "https://github.com/microsoft/onnxruntime-genai/releases/tag/v${version}";
    # https://github.com/microsoft/onnxruntime/blob/master/BUILD.md#architectures
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ anpin ];
  };
}
