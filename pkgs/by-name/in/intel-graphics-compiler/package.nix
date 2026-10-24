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
  spirv-headers,
  spirv-tools,
}:

let
  llvmVersion = "22.1.8";
in
stdenv.mkDerivation rec {
  pname = "intel-graphics-compiler";
  version = "2.41.15";

  # See the repository for expected versions:
  # <https://github.com/intel/intel-graphics-compiler/blob/v2.16.0/documentation/build_ubuntu.md#revision-table>
  srcs = [
    (fetchFromGitHub {
      name = "igc";
      owner = "intel";
      repo = "intel-graphics-compiler";
      tag = "v${version}";
      hash = "sha256-msKpMkzTyczjLIkmiLmw8QFrsnT6VsB+RDGRSBXHimA=";
    })
    (fetchFromGitHub {
      name = "llvm-project";
      owner = "llvm";
      repo = "llvm-project";
      tag = "llvmorg-${llvmVersion}";
      hash = "sha256-SF7wFuh4kXZTytpdgX7vUZItKtRobnVICm+ixze4iG0=";
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
      tag = "v22.1.4";
      hash = "sha256-pd1HLp/PzSWJASkl+wMs0J+mwxojv79idXJx8s4ygaQ=";
    })
    (fetchFromGitHub {
      name = "llvm-spirv";
      owner = "KhronosGroup";
      repo = "SPIRV-LLVM-Translator";
      tag = "v22.1.5";
      hash = "sha256-5qqkYcG8JGaLldD9PvbMKUURPpucD44voezQlaQuPmk=";
    })
  ];

  patches = [
    ./fix-create-directories-to-apply-patches.diff
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

    # Their slapdash CMake code checks the exit code of "git rev-parse" whether patches must be applied.
    # Since we do not have a full git repo and cannot clone one due to reproducibility issues,
    # git exits with 128 which is in newer versions of opencl-clang logged as a STATUS, but does not abort either.
    # We could hack around this, but since we are certain we want the patches (eg for CL3.1), we just shortcircuit the condition.
    substituteInPlace llvm-project/llvm/projects/opencl-clang/cmake/modules/CMakeFunctions.cmake \
      --replace-fail "if(patches_needed EQUAL 1)" "if(TRUE)"

    # "git am" wants to check the git history if the commit is already applied, but we do not have that.
    # "git apply" works very similar, but without a git history and supports the same options unlike patch.
    substituteInPlace llvm-project/llvm/projects/opencl-clang/cmake/modules/CMakeFunctions.cmake \
      --replace-fail 'COMMAND ''${GIT_EXECUTABLE} am --3way --keep-non-patch --ignore-whitespace' \
                     'COMMAND ''${GIT_EXECUTABLE} apply --3way --ignore-whitespace -C0'

    # The build system only applies patches when the sources are in a Git repository.
    export HOME=$(mktemp -d)
    git config --global user.email ""
    git config --global user.name nixbld
    git config --global gc.auto 0
    git -C llvm-project init
    git -C llvm-project add .
    git -C llvm-project commit -m stub >/dev/null
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
    maintainers = with lib.maintainers; [
      SuperSandro2000
      recutita
    ];
  };
}
