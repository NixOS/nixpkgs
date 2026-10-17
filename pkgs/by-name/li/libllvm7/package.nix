{
  lib,
  gcc13Stdenv,
  fetchurl,
  cmake,
  ninja,
  python3,
  zlib,
}:

# Needed by numba-cuda-mlir to support GPUs below sm_100.
gcc13Stdenv.mkDerivation (finalAttrs: {
  pname = "libllvm7";
  version = "7.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/llvm/llvm-project/releases/download/llvmorg-${finalAttrs.version}/llvm-${finalAttrs.version}.src.tar.xz";
    hash = "sha256-G8ybKFB03th7iPqu3duI5rXWwzHfz7V9fzOT3WIrN2Q=";
  };

  # CMP0051 was removed in cmake 4
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        "cmake_policy(SET CMP0051 OLD)" \
        "cmake_policy(SET CMP0051 NEW)"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    python3
  ];

  buildInputs = [
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
    (lib.cmakeFeature "LLVM_TARGETS_TO_BUILD" "NVPTX")
    (lib.cmakeBool "LLVM_BUILD_LLVM_DYLIB" true)
    (lib.cmakeBool "LLVM_BUILD_TOOLS" false)
    (lib.cmakeBool "LLVM_BUILD_UTILS" false)
    (lib.cmakeBool "LLVM_BUILD_EXAMPLES" false)
    (lib.cmakeBool "LLVM_INCLUDE_TESTS" false)
    (lib.cmakeBool "LLVM_INCLUDE_BENCHMARKS" false)
    (lib.cmakeBool "LLVM_INCLUDE_DOCS" false)
    (lib.cmakeBool "LLVM_ENABLE_TERMINFO" false)
    (lib.cmakeBool "LLVM_ENABLE_ZLIB" true)
  ];

  ninjaFlags = [ "LLVM" ];

  installPhase = ''
    runHook preInstall

    install -Dm555 lib/libLLVM-7*.so $out/lib/libLLVM-7.so

    runHook postInstall
  '';

  meta = {
    description = "LLVM 7 shared library, for numba-cuda-mlir's NVVM IR downgrade path";
    homepage = "https://llvm.org/";
    license = lib.licenses.ncsa;
    teams = [ lib.teams.cuda ];
    platforms = lib.platforms.linux;
  };
})
