{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  git,
  bison,
  flex,
  zlib,
  intel-compute-runtime,
  python3,
  spirv-tools,
  spirv-headers,
}:

let
  llvmVersion = "16.0.6";
in
stdenv.mkDerivation rec {
  pname = "intel-graphics-compiler";
<<<<<<< HEAD
  version = "2.24.8";
=======
  version = "2.22.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # See the repository for expected versions:
  # <https://github.com/intel/intel-graphics-compiler/blob/v2.16.0/documentation/build_ubuntu.md#revision-table>
  srcs = [
    (fetchFromGitHub {
      name = "igc";
      owner = "intel";
      repo = "intel-graphics-compiler";
      tag = "v${version}";
<<<<<<< HEAD
      hash = "sha256-h/YlZatUn61M5/F4msJljZDWcQyivgCAi1HC9CXvTts=";
=======
      hash = "sha256-4Tp9kY+Sbirf4kN/C5Q1ClcoUI/fhfUJpqL+/eO8a/o=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    })
    (fetchFromGitHub {
      name = "llvm-project";
      owner = "llvm";
      repo = "llvm-project";
      tag = "llvmorg-${llvmVersion}";
      hash = "sha256-fspqSReX+VD+Nl/Cfq+tDcdPtnQPV1IRopNDfd5VtUs=";
    })
    (fetchFromGitHub {
      name = "vc-intrinsics";
      owner = "intel";
      repo = "vc-intrinsics";
<<<<<<< HEAD
      tag = "v0.24.1";
      hash = "sha256-IpScRc+sWEcD8ZH5TinMPVFq1++vIVp774TJsg8mUMY=";
=======
      tag = "v0.23.4";
      hash = "sha256-zorhOhBTcymnAlShJxJecXD+HIfScGouhSea/A3tBXE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    })
    (fetchFromGitHub {
      name = "opencl-clang";
      owner = "intel";
      repo = "opencl-clang";
<<<<<<< HEAD
      tag = "v16.0.6";
      hash = "sha256-qxMnKQWQ32yF2rZGGOel2ynZJKfbAlk9U+ttWuzYRog=";
=======
      tag = "v16.0.5";
      hash = "sha256-JfynEsCXltVdVY/LqWvZwzWfzEFUz6nI9Zub+bze1zE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    })
    (fetchFromGitHub {
      name = "llvm-spirv";
      owner = "KhronosGroup";
      repo = "SPIRV-LLVM-Translator";
<<<<<<< HEAD
      tag = "v16.0.19";
      hash = "sha256-GTTEThCNPyq0CpD6Vp4L0ZEEqOZ7uLbt9sdgXLs7MUg=";
=======
      tag = "v16.0.18";
      hash = "sha256-JwFwjHUv1tBC7KDWAhkse557R6QCaVjOekhndQlVetM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    })
  ];

  patches = [
    # Raise minimum CMake version to 3.5
    # https://github.com/intel/intel-graphics-compiler/commit/4f0123a7d67fb716b647f0ba5c1ab550abf2f97d
    # https://github.com/intel/intel-graphics-compiler/pull/364
    ./bump-cmake.patch
<<<<<<< HEAD

    # Fix for GCC 15 by adding a previously-implicit `#include <cstdint>` and
    # replacing `<ciso646>` with `<version>` in the the llvm directory. Based
    # on https://github.com/intel/intel-graphics-compiler/pull/383.
    ./gcc15-llvm-header-fixes.patch

    # Fix for GCC 15 by disabling `-Werror` for `-Wfree-nonheap-object`
    # warnings within LLVM. This is in accordance with IGC disabling warnings
    # that originate from within LLVM (see `IGC/common/LLVMWarningsPush.hpp`).
    ./gcc15-allow-llvm-free-nonheap-object-warning.patch
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  sourceRoot = ".";

  cmakeDir = "../igc";

  postUnpack = ''
    chmod -R +w .
    mv opencl-clang llvm-spirv llvm-project/llvm/projects/
  '';

  postPatch = ''
    substituteInPlace igc/IGC/AdaptorOCL/igc-opencl.pc.in \
      --replace-fail '/@CMAKE_INSTALL_INCLUDEDIR@' "/include" \
      --replace-fail '/@CMAKE_INSTALL_LIBDIR@' "/lib"

    chmod +x igc/IGC/Scripts/igc_create_linker_script.sh
    patchShebangs --build igc/IGC/Scripts/igc_create_linker_script.sh

    # The build system only applies patches when the sources are in a
    # Git repository.
    git -C llvm-project init
    git -C llvm-project -c user.name=nixbld -c user.email= commit --allow-empty -m stub
    substituteInPlace llvm-project/llvm/projects/opencl-clang/cmake/modules/CMakeFunctions.cmake \
<<<<<<< HEAD
      --replace-fail 'COMMAND ''${GIT_EXECUTABLE} am --3way --keep-non-patch --ignore-whitespace -C0 ' \
=======
      --replace-fail 'COMMAND ''${GIT_EXECUTABLE} am --3way --ignore-whitespace -C0 ' \
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
                     'COMMAND patch -p1 --ignore-whitespace -i '

    # match default LLVM version with our provided version to apply correct patches
    substituteInPlace igc/external/llvm/llvm_preferred_version.cmake \
      --replace-fail "16.0.6" "${llvmVersion}"
  '';

  nativeBuildInputs = [
    bison
    cmake
    flex
    git
    ninja
    (python3.withPackages (
      ps: with ps; [
        mako
        pyyaml
      ]
    ))
    zlib
  ];

  buildInputs = [
    spirv-headers
    spirv-tools
  ];

  strictDeps = true;

  # testing is done via intel-compute-runtime
  doCheck = false;

  cmakeFlags = [
    "-DIGC_OPTION__SPIRV_TOOLS_MODE=Prebuilds"
    "-DIGC_OPTION__USE_PREINSTALLED_SPIRV_HEADERS=ON"
    "-DSPIRV-Headers_INCLUDE_DIR=${spirv-headers}/include"
    "-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${spirv-headers.src}"
    "-Wno-dev"
  ];

  passthru.tests = {
    inherit intel-compute-runtime;
  };

<<<<<<< HEAD
  meta = {
    description = "LLVM-based compiler for OpenCL targeting Intel Gen graphics hardware";
    homepage = "https://github.com/intel/intel-graphics-compiler";
    changelog = "https://github.com/intel/intel-graphics-compiler/releases/tag/${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
=======
  meta = with lib; {
    description = "LLVM-based compiler for OpenCL targeting Intel Gen graphics hardware";
    homepage = "https://github.com/intel/intel-graphics-compiler";
    changelog = "https://github.com/intel/intel-graphics-compiler/releases/tag/${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
