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
}:

let
  llvmVersion = "17.0.6";

  spirv-headers = stdenv.mkDerivation {
    pname = "spirv-headers";
    version = "1.4.341.0-unstable-2026-04-29";

    src = fetchFromGitHub {
      owner = "KhronosGroup";
      repo = "SPIRV-Headers";
      rev = "b8a32968473ce852a809b9de5f04f02a5a9dfa78";
      hash = "sha256-k5lAF7TxJ+8cXDnx7lQxG/3IjSTzYcqBl5PYY2gv9E8=";
    };

    nativeBuildInputs = [ cmake ];
  };
in
stdenv.mkDerivation rec {
  pname = "intel-graphics-compiler";
  version = "2.36.3";

  # See the repository for expected versions:
  # <https://github.com/intel/intel-graphics-compiler/blob/v2.16.0/documentation/build_ubuntu.md#revision-table>
  srcs = [
    (fetchFromGitHub {
      name = "igc";
      owner = "intel";
      repo = "intel-graphics-compiler";
      tag = "v${version}";
      hash = "sha256-0GzZQECcngF9b5lZyeIKXeM6w64WzCYFtHOobQKN80o=";
    })
    (fetchFromGitHub {
      name = "llvm-project";
      owner = "llvm";
      repo = "llvm-project";
      tag = "llvmorg-${llvmVersion}";
      hash = "sha256-8MEDLLhocshmxoEBRSKlJ/GzJ8nfuzQ8qn0X/vLA+ag=";
    })
    (fetchFromGitHub {
      name = "vc-intrinsics";
      owner = "intel";
      repo = "vc-intrinsics";
      tag = "v0.25.0";
      hash = "sha256-ozc1w3V5RqWHwqNHuefZJMN8RAYxrJxH9bd1BEqxfiQ=";
    })
    (fetchFromGitHub {
      name = "opencl-clang";
      owner = "intel";
      repo = "opencl-clang";
      tag = "v17.0.7";
      hash = "sha256-7kQlH1Y4pnNvj/CS2qAVbYUl9FQWBuMew7i8CpORfKE=";
    })
    (fetchFromGitHub {
      name = "llvm-spirv";
      owner = "KhronosGroup";
      repo = "SPIRV-LLVM-Translator";
      tag = "v17.0.24";
      hash = "sha256-s/dNWmT3KXdXK0CSVjqEfsY9r8ONAGMZ5KUy9FeqF0E=";
    })
  ];

  patches = [
    # Fix for GCC 15 by adding a previously-implicit `#include <cstdint>` and
    # replacing `<ciso646>` with `<version>` in the the llvm directory. Based
    # on https://github.com/intel/intel-graphics-compiler/pull/383.
    ./gcc15-llvm-header-fixes.patch

    # Fix for GCC 15 by disabling `-Werror` for `-Wfree-nonheap-object`
    # warnings within LLVM. This is in accordance with IGC disabling warnings
    # that originate from within LLVM (see `IGC/common/LLVMWarningsPush.hpp`).
    ./gcc15-allow-llvm-free-nonheap-object-warning.patch
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
      --replace-fail 'COMMAND ''${GIT_EXECUTABLE} am --3way --keep-non-patch --ignore-whitespace -C0 ' \
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

  meta = {
    description = "LLVM-based compiler for OpenCL targeting Intel Gen graphics hardware";
    homepage = "https://github.com/intel/intel-graphics-compiler";
    changelog = "https://github.com/intel/intel-graphics-compiler/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
