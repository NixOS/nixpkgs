{ config
, lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, ninja
, git
, doxygen
, sphinx
, libxml2
, libxcrypt
, libedit
, libffi
, mpfr
, zlib
, ncurses
, python3Packages
, buildDocs ? true
, buildMan ? true
, buildTests ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openai-triton-llvm";
  version = "14.0.6-f28c006a5895";

  outputs = [
    "out"
  ] ++ lib.optionals buildDocs [
    "doc"
  ] ++ lib.optionals buildMan [
    "man"
  ];

  # See https://github.com/openai/triton/blob/main/python/setup.py and https://github.com/ptillet/triton-llvm-releases/releases
  src = fetchFromGitHub {
    owner = "llvm";
    repo = "llvm-project";
    rev = "f28c006a5895fc0e329fe15fead81e37457cb1d1";
    hash = "sha256-vffu4HilvYwtzwgq+NlS26m65DGbp6OSSne2aje1yJE=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    ninja
    git
    python3Packages.python
  ] ++ lib.optionals (buildDocs || buildMan) [
    doxygen
    sphinx
    python3Packages.recommonmark
  ];

  buildInputs = [
    libxml2
    libxcrypt
    libedit
    libffi
    mpfr
  ];

  propagatedBuildInputs = [
    zlib
    ncurses
  ];

  sourceRoot = "${finalAttrs.src.name}/llvm";

  cmakeFlags = [
    "-DLLVM_TARGETS_TO_BUILD=${
      let
        # Targets can be found in
        # https://github.com/llvm/llvm-project/tree/f28c006a5895fc0e329fe15fead81e37457cb1d1/clang/lib/Basic/Targets
        # NOTE: Unsure of how "host" would function, especially given that we might be cross-compiling.
        llvmTargets = [ "AMDGPU" "NVPTX" ]
        ++ lib.optionals stdenv.isAarch64 [ "AArch64" ]
        ++ lib.optionals stdenv.isx86_64 [ "X86" ];
      in
      lib.concatStringsSep ";" llvmTargets
    }"
    "-DLLVM_ENABLE_PROJECTS=llvm;mlir"
    "-DLLVM_INSTALL_UTILS=ON"
  ] ++ lib.optionals (buildDocs || buildMan) [
    "-DLLVM_INCLUDE_DOCS=ON"
    "-DMLIR_INCLUDE_DOCS=ON"
    "-DLLVM_BUILD_DOCS=ON"
    # "-DLLVM_ENABLE_DOXYGEN=ON" Way too slow, only uses one core
    "-DLLVM_ENABLE_SPHINX=ON"
    "-DSPHINX_OUTPUT_HTML=ON"
    "-DSPHINX_OUTPUT_MAN=ON"
    "-DSPHINX_WARNINGS_AS_ERRORS=OFF"
  ] ++ lib.optionals buildTests [
    "-DLLVM_INCLUDE_TESTS=ON"
    "-DMLIR_INCLUDE_TESTS=ON"
    "-DLLVM_BUILD_TESTS=ON"
  ];

  postPatch = ''
    # `CMake Error: cannot write to file "/build/source/llvm/build/lib/cmake/mlir/MLIRTargets.cmake": Permission denied`
    chmod +w -R ../mlir

    # FileSystem permissions tests fail with various special bits
    rm test/tools/llvm-objcopy/ELF/mirror-permissions-unix.test
    rm unittests/Support/Path.cpp

    substituteInPlace unittests/Support/CMakeLists.txt \
      --replace "Path.cpp" ""
  '';

  doCheck = buildTests;
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage = "https://github.com/llvm/llvm-project";
    license = with licenses; [ ncsa ];
    maintainers = with maintainers; [ SomeoneSerge Madouura ];
    platforms = platforms.linux;
    # Consider the derivation broken if we're not building for CUDA or ROCm, or if we're building for aarch64
    # and ROCm is enabled. See https://github.com/RadeonOpenCompute/ROCm/issues/1831#issuecomment-1278205344.
    broken = stdenv.isAarch64 && !config.cudaSupport;
  };
})
