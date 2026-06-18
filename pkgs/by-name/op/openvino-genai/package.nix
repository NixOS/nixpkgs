{
  lib,
  stdenv,
  fetchFromGitHub,
  autoPatchelfHook,
  cmake,
  gtest,
  nix-update-script,
  nlohmann_json,
  ocl-icd,
  opencl-clhpp,
  opencl-headers,
  onetbb,
  openvino,
  openvino-tokenizers,
  pkg-config,
  python3Packages,
}:

let
  inherit (lib) cmakeBool cmakeFeature;

  minja-src = fetchFromGitHub {
    owner = "google";
    repo = "minja";
    rev = "3e4c61c616eda133cfb1e440fc7a14bf1729bbee";
    hash = "sha256-aqOpLNB7XiY/W2gDRtnAqx37gMhHMRCJQmcX24vGIxA=";
  };

  safetensors-h-src = fetchFromGitHub {
    owner = "hsnyder";
    repo = "safetensors.h";
    rev = "974a85d7dfd6e010558353226638bb26d6b9d756";
    hash = "sha256-sBgm4panHB9X2RghC3Qi0wEL0k9uUz+h60pfxTGZ0BA=";
  };

  gguflib-src = fetchFromGitHub {
    owner = "Lourdle";
    repo = "gguf-tools";
    rev = "bac796ada809ac293e685db59b075971181cb008";
    hash = "sha256-yoIjTATYs2IzT/LnCz+G6PtxVXZ27B0mZOIipZbaOI8=";
  };

  python = python3Packages.python.withPackages (ps: [ ps.pybind11 ]);

  # How the build system calls the different platforms
  archName =
    {
      "aarch64-linux" = "aarch64";
      "x86_64-linux" = "intel64";
    }
    .${stdenv.hostPlatform.system};
in

stdenv.mkDerivation (finalAttrs: {
  pname = "openvino-genai";
  version = "2026.2.1.0";

  __structuredAttrs = true;

  src =
    assert lib.hasPrefix openvino.version finalAttrs.version;
    fetchFromGitHub {
      owner = "openvinotoolkit";
      repo = "openvino.genai";
      tag = finalAttrs.version;
      hash = "sha256-M8xxOsNvtIYIKvkrmOUnKv6gL/RAGuBfTBu3OPm3zRk=";
    };

  outputs = [
    "out"
    "dev"
    "python"
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    pkg-config
    python
  ];

  buildInputs = [
    nlohmann_json
    ocl-icd
    opencl-clhpp
    opencl-headers
    onetbb
    openvino
  ];

  strictDeps = true;

  patches = [
    # gguf_utils' format() is a function template declared in gguf.hpp but
    # defined in gguf.cpp, so instantiations from other TUs are unresolved at
    # link time (surfaces as an ImportError on libopenvino_genai.so load).
    # Move the definition into the header.
    ./move-gguf-format-template-into-header.patch
  ];

  postPatch = ''
    # pybind11 3.0 removed keep_alive support from def_property/def_readwrite.
    # parsers is vector<shared_ptr<Parser>> so shared_ptr ref-counting is sufficient.
    substituteInPlace src/python/py_generation_config.cpp \
      --replace-fail ', py::keep_alive<1, 2>()' ""
  '';

  cmakeFlags = [
    # Point cmake's FetchContent at pre-packaged nixpkgs sources so nothing is
    # downloaded at build time.
    (cmakeFeature "FETCHCONTENT_SOURCE_DIR_NLOHMANN_JSON" "${nlohmann_json.src}")
    (cmakeFeature "FETCHCONTENT_SOURCE_DIR_MINJA" "${minja-src}")
    (cmakeFeature "FETCHCONTENT_SOURCE_DIR_SAFETENSORS.H" "${safetensors-h-src}")
    (cmakeFeature "FETCHCONTENT_SOURCE_DIR_PYBIND11" "${python3Packages.pybind11.src}")
    (cmakeFeature "FETCHCONTENT_SOURCE_DIR_GGUFLIB" "${gguflib-src}")
    (cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${gtest.src}")
    (cmakeFeature "Python3_EXECUTABLE" "${python.interpreter}")
    (cmakeFeature "OpenVINO_DIR" "${openvino}/runtime/cmake")

    # Normalise install destinations to the standard Nix layout.
    (cmakeFeature "ARCHIVE_DESTINATION" "lib")
    (cmakeFeature "LIBRARY_DESTINATION" "lib")
    (cmakeFeature "RUNTIME_DESTINATION" "bin")

    (cmakeBool "ENABLE_SYSTEM_OPENCL" true)
    # Tokenizers are provided at runtime by openvino-tokenizers (C++) and
    # python3Packages.openvino-tokenizers; don't build them into this output.
    (cmakeBool "BUILD_TOKENIZERS" false)
    (cmakeBool "ENABLE_GGUF" true)
    (cmakeBool "ENABLE_PYTHON" true)
    (cmakeBool "ENABLE_SAMPLES" false)
    (cmakeBool "ENABLE_TESTS" true)
    (cmakeBool "ENABLE_TOOLS" false)
    (cmakeBool "ENABLE_XGRAMMAR" false)
  ];

  postInstall = ''
    # cmake installs to runtime/{include,cmake,lib/...}; move to standard paths.
    mkdir -p $dev/include $dev/lib/cmake $out/lib
    cp -r $out/runtime/include/. $dev/include/
    cp -r $out/runtime/cmake/. $dev/lib/cmake/

    # Copy any shared libraries cmake put in runtime/lib subdirs (e.g. intel64/)
    # before we remove the runtime/ tree.
    find $out/runtime \( -name '*.so' -o -name '*.so.*' \) -print0 \
      | xargs -0r cp -Pft $out/lib/
    rm -rf $out/runtime

    # The generated cmake targets files compute _IMPORT_PREFIX relative to
    # their location and use it to reference headers and libraries; fix those
    # paths to absolute nix store paths since we've reorganised the tree.
    substituteInPlace $dev/lib/cmake/OpenVINOGenAITargets.cmake \
      --replace-fail \
        "\''${_IMPORT_PREFIX}/runtime/include" "$dev/include"
    substituteInPlace $dev/lib/cmake/OpenVINOGenAITargets-release.cmake \
      --replace-fail \
        "\''${_IMPORT_PREFIX}/runtime/lib/${archName}/" "$out/lib/"
  '';

  preFixup = ''
    addAutoPatchelfSearchPath ${lib.getLib openvino}/runtime/lib/${archName}
  '';

  postFixup = ''
    # Split Python module into its own output.
    mkdir -p $python
    cp -r $out/python/. $python/
    rm -rf $out/python

    # Help autoPatchelfHook find: (1) libopenvino_genai.so.* in our own $out/lib
    # when patching the $python output, (2) libopenvino.so.* which openvino
    # installs to runtime/lib/intel64/ instead of lib/.
    autoPatchelfLibs+=("$out/lib" "${openvino}/runtime/lib/intel64")
  '';

  nativeCheckInputs = [ openvino-tokenizers ];

  # C++ exception with description "Exception from src/inference/src/cpp/core.cpp:272:
  # Exception from src/inference/src/dev/core_impl.cpp:706:
  # Device with "CPU" name is not registered in the OpenVINO Runtime
  doCheck = !stdenv.hostPlatform.isAarch64;

  preCheck = ''
    mkdir -p tests/cpp/data
    cp -r ${finalAttrs.src}/tests/cpp/data/. tests/cpp/data/
    export OPENVINO_TOKENIZERS_PATH_GENAI="${openvino-tokenizers}/lib/libopenvino_tokenizers.so"
  '';

  checkPhase = ''
    runHook preCheck
    # GetCacheTypesRealModel and LLMPipelineBackendRealModel require on-disk
    # model data (CACHE_TYPES_CSV + TEST_MODELS_BASE_DIR) unavailable in the
    # Nix sandbox; with zero ValuesIn entries GTest ≥ 1.12 reports them via
    # GoogleTestVerification.UninstantiatedParameterizedTestSuite<*>, so
    # exclude that verification check for these two suites.
    ./tests/cpp/tests_continuous_batching \
      --gtest_filter="-GoogleTestVerification.UninstantiatedParameterizedTestSuite*"
    runHook postCheck
  '';

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Generative AI inference pipeline library built on OpenVINO Runtime";
    longDescription = ''
      OpenVINO GenAI provides a high-level C++ and Python API for running large
      language models and other generative AI workloads using OpenVINO Runtime as
      the inference backend. It supports continuous batching, speculative decoding,
      and a range of text, image, and speech generation pipelines.
    '';
    homepage = "https://github.com/openvinotoolkit/openvino.genai";
    changelog = "https://github.com/openvinotoolkit/openvino.genai/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ jpds ];
  };
})
