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

stdenv.mkDerivation rec {
  pname = "intel-graphics-compiler";
  version = "2.18.5";

  # See the repository for expected versions:
  # <https://github.com/intel/intel-graphics-compiler/blob/v2.16.0/documentation/build_ubuntu.md#revision-table>
  srcs = [
    (fetchFromGitHub {
      name = "igc";
      owner = "intel";
      repo = "intel-graphics-compiler";
      tag = "v${version}";
      hash = "sha256-AvEeK3rySEu89br4JgeZlXVQ6IXEzStVZYvehzdWq7g=";
    })
    (fetchFromGitHub {
      name = "llvm-project";
      owner = "llvm";
      repo = "llvm-project";
      tag = "llvmorg-15.0.7";
      hash = "sha256-wjuZQyXQ/jsmvy6y1aksCcEDXGBjuhpgngF3XQJ/T4s=";
    })
    (fetchFromGitHub {
      name = "vc-intrinsics";
      owner = "intel";
      repo = "vc-intrinsics";
      tag = "v0.23.1";
      hash = "sha256-7coQegLcgIKiqnonZmgrKlw6FCB3ltSh6oMMvdopeQc=";
    })
    (fetchFromGitHub {
      name = "opencl-clang";
      owner = "intel";
      repo = "opencl-clang";
      tag = "v15.0.3";
      hash = "sha256-JkYFmnDh7Ot3Br/818aLN33COEG7+xyOf8OhdoJX9Cw==";
    })
    (fetchFromGitHub {
      name = "llvm-spirv";
      owner = "KhronosGroup";
      repo = "SPIRV-LLVM-Translator";
      tag = "v15.0.15";
      hash = "sha256-kFVDS+qwoG1AXrZ8LytoiLVbZkTGR9sO+Wrq3VGgWNQ=";
    })
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
