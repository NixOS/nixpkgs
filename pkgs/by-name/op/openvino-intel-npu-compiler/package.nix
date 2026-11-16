{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  python3,
  gitMinimal,
  level-zero,
  onetbb,
  pugixml,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openvino-intel-npu-compiler";
  version = "2026.38-rc1";

  src = fetchFromGitHub {
    owner = "openvinotoolkit";
    repo = "npu_compiler";
    tag = "npu_ud_" + lib.replaceStrings [ "." "-" ] [ "_" "_" ] finalAttrs.version;
    fetchLFS = true;
    fetchSubmodules = true;
    hash = "sha256-rXUysfCLKc3VKavc3lG8BZtWLgvQVPTI/QP11Xk8F/Y=";
  };

  # Must be the revision from validation/openvino_config.json: building against
  # the openvino package's source fails (ov::util::XmlDeserializer API changed).
  openvinoSrc = fetchFromGitHub {
    owner = "openvinotoolkit";
    repo = "openvino";
    rev = "d8047fb380b27a9d5827cb3f22aec7781ae5ac82";
    fetchSubmodules = true;
    hash = "sha256-djEof2C5T5EyKz5hy4TQdW0Q1WHZYVHYFLujox90r/I=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    gitMinimal
  ];

  buildInputs = [
    onetbb
    pugixml
  ];

  strictDeps = true;
  __structuredAttrs = true;

  # GCC 16 trips the project's -Werror; disable it globally.
  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  postUnpack = ''
    cp -r --no-preserve=mode ${finalAttrs.openvinoSrc}/. "$sourceRoot"/openvino/
  '';

  # Stage the CiD preset where the build looks for it, and cover the missing
  # `.git` directory (upstream aborts when `git rev-parse` fails).
  postPatch = ''
    cp CMakePresets.json openvino/CMakePresets.json
    substituteInPlace cmake/compiler_commit_hash.cmake \
      --replace-fail 'message(FATAL_ERROR "Failed to capture compiler git commit.")' \
      'set(CURRENT_COMMIT_HASH "unknown")'
  '';

  cmakeDir = "../openvino";

  preConfigure = ''
    export NPU_PLUGIN_HOME=$PWD
    export CONFIG=Release
  '';

  cmakeFlags = [
    "--preset"
    "cid-linux"
    # The preset builds in openvino/build_Release; keep it in build/.
    "-B"
    "."
    (lib.cmakeBool "ENABLE_NPU_PLUGIN_ENGINE" true)
    (lib.cmakeBool "ENABLE_SYSTEM_TBB" true)
    (lib.cmakeBool "ENABLE_SYSTEM_PUGIXML" true)
    # The preset sets a ccache launcher, which the build sandbox does not have.
    "-DCMAKE_C_COMPILER_LAUNCHER="
    "-DCMAKE_CXX_COMPILER_LAUNCHER="
    "-Wno-dev"
  ];

  ninjaFlags = [
    "openvino_intel_npu_compiler"
    "openvino_intel_npu_compiler_loader"
    "openvino_intel_npu_vm_runtime"
  ];

  # Only CiD's libraries and headers are needed, everything else is deleted.
  installPhase = ''
    runHook preInstall
    cmake --install . --component CiD --prefix $out
    mv $out/cid/lib $out/cid/include $out/
    rm -rf $out/cid
    runHook postInstall
  '';

  postFixup = ''
    # CMake links the bundled level-zero loader; use nixpkgs' instead.
    patchelf --add-rpath ${lib.makeLibraryPath [ level-zero ]} $out/lib/*.so
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "OpenVINO Intel NPU Compiler (VPUXCompilerL0)";
    homepage = "https://github.com/openvinotoolkit/npu_compiler";
    # Bundles a pinned LLVM/MLIR snapshot (Apache-2.0 WITH LLVM-exception) and
    # Apache-2.0 code (compiler, npu_elf runtime, cost model).
    license =
      with lib.licenses;
      AND [
        asl20
        (WITH asl20 llvm-exception)
      ];
    maintainers = with lib.maintainers; [ ryan4yin ];
    platforms = [ "x86_64-linux" ];
  };
})
