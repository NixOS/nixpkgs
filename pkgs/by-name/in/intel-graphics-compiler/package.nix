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
  version = "2.22.2";

  # See the repository for expected versions:
  # <https://github.com/intel/intel-graphics-compiler/blob/v2.16.0/documentation/build_ubuntu.md#revision-table>
  srcs = [
    (fetchFromGitHub {
      name = "igc";
      owner = "intel";
      repo = "intel-graphics-compiler";
      tag = "v${version}";
      hash = "sha256-4Tp9kY+Sbirf4kN/C5Q1ClcoUI/fhfUJpqL+/eO8a/o=";
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
      tag = "v0.23.4";
      hash = "sha256-zorhOhBTcymnAlShJxJecXD+HIfScGouhSea/A3tBXE=";
    })
    (fetchFromGitHub {
      name = "opencl-clang";
      owner = "intel";
      repo = "opencl-clang";
      tag = "v16.0.5";
      hash = "sha256-JfynEsCXltVdVY/LqWvZwzWfzEFUz6nI9Zub+bze1zE=";
    })
    (fetchFromGitHub {
      name = "llvm-spirv";
      owner = "KhronosGroup";
      repo = "SPIRV-LLVM-Translator";
      tag = "v16.0.18";
      hash = "sha256-JwFwjHUv1tBC7KDWAhkse557R6QCaVjOekhndQlVetM=";
    })
  ];

  patches = [
    # Raise minimum CMake version to 3.5
    # https://github.com/intel/intel-graphics-compiler/commit/4f0123a7d67fb716b647f0ba5c1ab550abf2f97d
    # https://github.com/intel/intel-graphics-compiler/pull/364
    ./bump-cmake.patch
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
      --replace-fail 'COMMAND ''${GIT_EXECUTABLE} am --3way --ignore-whitespace -C0 ' \
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

  meta = with lib; {
    description = "LLVM-based compiler for OpenCL targeting Intel Gen graphics hardware";
    homepage = "https://github.com/intel/intel-graphics-compiler";
    changelog = "https://github.com/intel/intel-graphics-compiler/releases/tag/${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
