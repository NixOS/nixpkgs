{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  ninja,

  # buildInputs
  protobuf,

  # checkInputs
  gtest,
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
    python
    scikit-build-core
    ;
in
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  pname = "onnx";
  version = "1.22.0";

  src = fetchFromGitHub {
    owner = "onnx";
    repo = "onnx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gc65t/VN3kdvV9tiFoOk6Sw+OZe4Udgm3VcZPP9gzpE=";
  };

  outputs = [
    "out"
    "dist" # Python wheel output
  ];

  nativeBuildInputs = [
    build
    cmake
    ninja
    python
    scikit-build-core
  ];

  # NOTE: python3Packages.protobuf does not propagate a dependency on protobuf's dev output, so we must bring it in
  # for the CMake files.
  buildInputs = [
    protobuf
    python3Packages.protobuf
  ];

  # Standalone C++ build directory for the libonnx C++ library (`out`).
  # Kept separate from the Python wheel's build directory (scikit-build-core hardcodes
  # `.setuptools-cmake-build` in pyproject.toml, where it builds onnx with ONNX_INSTALL=OFF):
  # sharing the directory would clobber this build's install prefix and leave `out` empty.
  cmakeBuildDir = "build-cpp";

  # scikit-build-core's cmake.define reads several of these from the environment (see pyproject.toml).
  env = {
    # NOTE: onnx is built statically on all platforms.
    # Since 1.22.0, libonnx is built with hidden symbol visibility, and ONNX refuses to combine
    # ONNX_BUILD_PYTHON=ON with BUILD_SHARED_LIBS=ON: both the Python extension and the C++ gtests
    # link ONNX internals not on the public API surface, which a hidden-visibility shared libonnx
    # does not export. Building statically (as Darwin already required) keeps the wheel and the C++
    # tests linkable.
    # No consumer links the C++ libonnx as a shared library (onnxruntime builds onnx from its own source).
    BUILD_SHARED_LIBS = "0";

    ONNX_BUILD_TESTS = if finalAttrs.finalPackage.doCheck then "1" else "0";
    # ONNX_ML is enabled by default.
    # See: https://github.com/onnx/onnx/blob/b751946c3d59a3c8358abcc0569b59e6ddb08cdd/CMakeLists.txt#L66-L73
    ONNX_ML = "1";
    ONNX_NAMESPACE = "onnx";
    ONNX_USE_PROTOBUF_SHARED_LIBS = "1";

    nanobind_DIR = "${python3Packages.nanobind}/${python.sitePackages}/nanobind/cmake";
  };

  cmakeFlags = mapAttrsToList cmakeFeature finalAttrs.env;

  preConfigure = ''
    export MAX_JOBS=$NIX_BUILD_CORES
  '';

  # Leave the CMake build directory, export the `cmakeFlags` as CMAKE_ARGS so scikit-build-core will
  # pick them up, build the Python wheel from the top-level, then resume the C++ build.
  preBuild = ''
    pushd ..
    nixLog "exporting cmakeFlags as CMAKE_ARGS for Python build"
    # Reuse the C++ build flags, additionally enabling the Python extension for the wheel.
    export CMAKE_ARGS="''${cmakeFlags[*]} -DONNX_BUILD_PYTHON=ON"
    nixLog "building Python wheel"
    # --skip-dependency-check: upstream pins protobuf==4.25.1 as a build dep, but we build against
    # nixpkgs' protobuf. --no-isolation: use the build tools from nativeBuildInputs.
    pyproject-build \
      --no-isolation \
      --skip-dependency-check \
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
