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
  version = "2026.38rc1";

  src = fetchFromGitHub {
    owner = "openvinotoolkit";
    repo = "npu_compiler";
    tag = "npu_ud_2026_38_rc1";
    fetchLFS = true;
    fetchSubmodules = true;
    hash = "sha256-rXUysfCLKc3VKavc3lG8BZtWLgvQVPTI/QP11Xk8F/Y=";
  };

  # The OpenVINO revision was taken from validation/openvino_config.json.
  # Upstream only guarantees compatibility with that exact commit, so this
  # pins its own source instead of reusing the openvino package's.
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

  # Makes install destinations prefix-relative so `cmake --install` lands in
  # `$out`, and drops the doc/header installs.
  patches = [
    ./fix-install-layout.patch
  ];

  # npu_compiler is built as an OPENVINO_EXTRA_MODULES module, so the matching
  # OpenVINO tree has to sit next to it.
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
    "-B"
    "."
    "-DENABLE_NPU_PLUGIN_ENGINE=ON"
    "-DENABLE_SYSTEM_TBB=ON"
    "-DENABLE_SYSTEM_PUGIXML=ON"
    "-DCMAKE_C_COMPILER_LAUNCHER="
    "-DCMAKE_CXX_COMPILER_LAUNCHER="
    "-Wno-dev"
  ];

  ninjaFlags = [
    "openvino_intel_npu_compiler"
    "openvino_intel_npu_compiler_loader"
    "openvino_intel_npu_vm_runtime"
  ];

  # `ninja install` installs every component; only CiD is needed.
  installPhase = ''
    runHook preInstall
    cmake --install . --component CiD --prefix $out
    runHook postInstall
  '';

  postFixup = ''
    # CMake linked the bundled level-zero loader, so point the libraries at
    # nixpkgs' level-zero.
    patchelf --add-rpath ${lib.makeLibraryPath [ level-zero ]} $out/lib/*.so
  '';

  passthru.updateScript = ./update.py;

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
