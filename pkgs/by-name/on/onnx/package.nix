{
  cmake,
  fetchFromGitHub,
  gtest,
  lib,
  ninja,
  protobuf,
  python3Packages,
  stdenv,
}:
let
  inherit (lib)
    cmakeFeature
    licenses
    maintainers
    mapAttrsToList
    ;
  inherit (python3Packages)
    build
    pybind11
    python
    setuptools
    ;
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "onnx";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "onnx";
    repo = "onnx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oWbrBx1jWznzeT2N+VrFH8LIqdzY/aXH5N0kb/vbg2M=";
  };

  outputs = [
    "out"
    "dist" # Python wheel output
  ];

  nativeBuildInputs = [
    build
    cmake
    ninja
    pybind11
    python
    setuptools
  ];

  # NOTE: Darwin requires a static build, so this patch is unnecessary on that platform.
  prePatch = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    nixLog "patching $PWD/CMakeLists.txt to fix symbol visibility"
    substituteInPlace "$PWD/CMakeLists.txt" \
      --replace-fail \
        'set_target_properties(onnx_object PROPERTIES CXX_VISIBILITY_PRESET hidden)' \
        '# set_target_properties(onnx_object PROPERTIES CXX_VISIBILITY_PRESET hidden)' \
      --replace-fail \
        'set_target_properties(onnx_object PROPERTIES VISIBILITY_INLINES_HIDDEN ON)' \
        '# set_target_properties(onnx_object PROPERTIES VISIBILITY_INLINES_HIDDEN ON)'
  '';

  # NOTE: python3Packages.protobuf does not propagate a dependency on protobuf's dev output, so we must bring it in
  # for the CMake files.
  buildInputs = [
    protobuf
    python3Packages.protobuf
  ];

  # Declared in setup.py
  cmakeBuildDir = ".setuptools-cmake-build";

  # Python setup.py just takes stuff from the environment.
  env = {
    # NOTE: Darwin requires a static build; otherwise, tests fail in the Python package.
    BUILD_SHARED_LIBS = if stdenv.hostPlatform.isDarwin then "0" else "1";
    ONNX_BUILD_PYTHON = "1";
    ONNX_BUILD_TESTS = if finalAttrs.doCheck then "1" else "0";
    # ONNX_ML is enabled by default, so we must explicitly disable it.
    # See: https://github.com/onnx/onnx/blob/b751946c3d59a3c8358abcc0569b59e6ddb08cdd/CMakeLists.txt#L66-L73
    # NOTE: If this is `true`, onnx-tensorrt fails to build due to missing protobuf files.
    ONNX_ML = "0";
    ONNX_NAMESPACE = "onnx";
    ONNX_USE_PROTOBUF_SHARED_LIBS = "1";

    nanobind_DIR = "${python3Packages.nanobind}/${python.sitePackages}/nanobind/cmake";
  };

  cmakeFlags = mapAttrsToList cmakeFeature finalAttrs.env;

  preConfigure = ''
    export MAX_JOBS=$NIX_BUILD_CORES
  '';

  # Leave the CMake bulid directory, export the `cmakeFlags` environment variable as CMAKE_ARGS so setup.py will pick
  # them up, do the python build from the top-level, then resume the C++ build.
  preBuild = ''
    pushd ..
    nixLog "exporting cmakeFlags as CMAKE_ARGS for Python build"
    export CMAKE_ARGS="''${cmakeFlags[*]}"
    nixLog "building Python wheel"
    pyproject-build \
      --no-isolation \
      --outdir "$dist/" \
      --wheel
    popd >/dev/null
  '';

  # NOTE: Python specific tests happen in the python package.
  doCheck = true;

  checkInputs = [ gtest ];

  preCheck = ''
    nixLog "running C++ tests with $PWD/onnx_gtests"
    "$PWD/onnx_gtests"
  '';

  postInstall = ''
    nixLog "removing empty directories in $out/include/onnx"
    find "$out/include/onnx" -type d -empty -delete
  '';

  meta = {
    description = "Open Neural Network Exchange";
    homepage = "https://onnx.ai";
    license = licenses.asl20;
    changelog = "https://github.com/onnx/onnx/releases/tag/v${finalAttrs.version}";
    maintainers = with maintainers; [
      acairncross
      connorbaker
    ];
  };
})
