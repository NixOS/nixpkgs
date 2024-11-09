{ config
, stdenv
, lib
, fetchFromGitHub
# , Foundation
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
, dlib
# , iconv
, protobuf_21
, pythonSupport ? true
, cudaSupport ? config.cudaSupport
, cudaPackages ? {}
, onnxruntime
, buildEnv
, simdjson
, opencv
, sentencepiece
, tree
, coreutils
}@inputs:


let
  version = "0.12.0";

  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else inputs.stdenv;

  cudaCapabilities = cudaPackages.cudaFlags.cudaCapabilities;
  # E.g. [ "80" "86" "90" ]
  cudaArchitectures = (builtins.map cudaPackages.cudaFlags.dropDot cudaCapabilities);
  cudaArchitecturesString = lib.strings.concatStringsSep ";" cudaArchitectures;

  ort = buildEnv { name = "ort"; paths = [  onnxruntime  onnxruntime.dev ]; };


  # Provide latest dr_libs.
  dr_libs = fetchFromGitHub {
    owner = "mackron";
    repo = "dr_libs";
    rev = "dd762b861ecadf5ddd5fb03e9ca1db6707b54fbb";
    hash = "sha256-DkE9wTwqvOkEauMqlkijvljPlpoEG5LZRKxMffkfg3c=";
  };
  # sentencepiece-static = fetchFromGitHub {
  #   owner = "google";
  #   repo = "sentencepiece";
  #   rev = "v0.1.96";
  #   hash = "sha256-jo8XlQJsnWpeeezDjNNhh6T473XMqe8fsApUr82Y3BU=";
  # };
  blingfire =  fetchFromGitHub {
    owner = "microsoft";
    repo = "blingfire";
    rev = "0831265c1aca95ca02eca5bf1155e4251e545328";
    hash = "sha256-NNS+ggDx3NYLYqyWWwP8dAtV/fTJgp4EHTJwRMgOmzQ=";
  };

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxruntime-extensions";
    rev = "refs/tags/v${version}";
    hash = "sha256-snFGnCHvHMX8IdiNzvvm8wB1LHBecUFTgDRMzVnKZxA=";
  };
  # sentencepiece_patched = sentencepiece.overrideAttrs(old: {
  #   version = "v0.1.96";
  #   src = fetchFromGitHub {
  #     owner = "google";
  #     repo = "sentencepiece";
  #     rev = "refs/tags/v0.1.96";
  #     sha256 = "sha256-jo8XlQJsnWpeeezDjNNhh6T473XMqe8fsApUr82Y3BU=";
  #   };
  #   patches = [
  #     "${src}/cmake/externals/sentencepieceproject_cmake.patch"
  #     "${src}/cmake/externals/sentencepieceproject_pb.patch"
  #   ];
  # });

 sentencepiece_patched =
 let patches = [
        "${src}/cmake/externals/sentencepieceproject_cmake.patch"
        "${src}/cmake/externals/sentencepieceproject_pb.patch"
      ]; in
  effectiveStdenv.mkDerivation {
      inherit patches;
      pname = "sentencepiece_patched";
      version = "v0.1.96";
      src = fetchFromGitHub {
        owner = "google";
        repo = "sentencepiece";
        rev = "refs/tags/v0.1.96";
        sha256 = "sha256-jo8XlQJsnWpeeezDjNNhh6T473XMqe8fsApUr82Y3BU=";
      };
      # Disable build and install phases
      # buildPhase = "true";
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        mkdir -p $out
        cp -r * $out
      '';
    };

in
effectiveStdenv.mkDerivation rec {
  pname = "onnxruntime-extensions";
  inherit version src;


  patches = [
    ./0001-patch-dependencies.patch
    ./0002-patch-dependencies.patch
    ./0003-patch-dependencies.patch
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
    # pythonOutputDistHook
    # setuptools
    # wheel
    # python3Packages.onnxruntime
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
    dlib
    opencv
    # opencv.cxxdev
    abseil-cpp
    protobuf_21
    re2
    # sentencepiece_patched


  ] ++ lib.optionals pythonSupport (with python3Packages; [
    numpy
    pybind11
    packaging
  ])
  # ++ lib.optionals effectiveStdenv.isDarwin [
  #   Foundation
  #   iconv
  # ]
   ++ lib.optionals cudaSupport (with cudaPackages; [
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
  outputs = [ "out" "dev"] ;

  enableParallelBuilding = true;

  cmakeDir = "cmake";

  cmakeFlags = [
    "-S .."
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DFETCHCONTENT_QUIET=OFF"
    "-DCMAKE_POSITION_INDEPENDENT_CODE=ON"
    "-DOCOS_ENABLE_STATIC_LIB=ON"
    "-DOCOS_ENABLE_C_API=ON"
    "-DOCOS_BUILD_PRESET=ort_genai"
    "-DOCOS_BUILD_PYTHON=${if pythonSupport then "ON" else "OFF"}"
    "-DONNXRUNTIME_PKG_DIR=${ort}"
    "-DOCOS_ONNXRUNTIME_VERSION=${onnxruntime.version}"
    "-DCMAKE_PREFIX_PATH=${protobuf_21}/lib/cmake"
    "-DFETCHCONTENT_SOURCE_DIR_GSL=${microsoft-gsl.src}"
    "-DFETCHCONTENT_SOURCE_DIR_DR_LIBS=${dr_libs}"
    "-DFETCHCONTENT_SOURCE_DIR_DLIB=${dlib.src}"
  ]
  ++ lib.optionals cudaSupport [
    "-DOCOS_USE_CUDA=ON"
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

  postInstall = ''
    cp lib/libortcustomops.a $out/lib/
    cp lib/libocos_operators.a $out/lib/
    cp lib/libnoexcep_operators.a $out/lib/
    cp lib/libextensions_pydll.so $out/lib/

    ln -s $out/lib/libortextensions.so  $out/lib/libonnxruntime_extensions.so

    cp -r $src/include $out/
    chmod +w $out/include
    cp $src/shared/api/*.h $out/include/
    cp $src/shared/api/*.hpp $out/include/
    cp $src/base/*.h $out/include/
  '';

  passthru = {
    inherit cudaSupport cudaPackages onnxruntime; # for the python module
    protobuf = protobuf_21;
    # tests = lib.optionalAttrs pythonSupport {
    #   python = python3Packages.onnxruntime-genai;
    # };
  };

  meta = with lib; {
    description = "A specialized pre- and post- processing library for ONNX Runtime ";
    longDescription = ''
      ONNXRuntime-Extensions is a C/C++ library that extends the capability of the ONNX models and inference with ONNX Runtime, via ONNX Runtime Custom Operator ABIs.
      It includes a set of ONNX Runtime Custom Operator to support the common pre- and post-processing operators for vision, text, and nlp models.
    '';
    homepage = "https://github.com/microsoft/onnxruntime-extensions";
    changelog = "https://github.com/microsoft/onnxruntime-extensions/releases/tag/v${version}";
    # https://github.com/microsoft/onnxruntime/blob/master/BUILD.md#architectures
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = with maintainers; [ anpin ];
  };
}
