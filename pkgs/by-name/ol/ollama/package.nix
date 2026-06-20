{
  lib,
  buildGoModule,
  fetchFromGitHub,
  buildEnv,
  makeBinaryWrapper,
  stdenv,
  addDriverRunpath,
  nix-update-script,

  cmake,
  gitMinimal,
  clblast,
  libdrm,
  rocmPackages,
  rocmGpuTargets ? rocmPackages.clr.localGpuTargets or (rocmPackages.clr.gpuTargets or [ ]),
  cudaPackages,
  cudaArches ? cudaPackages.flags.realArches or [ ],
  autoAddDriverRunpath,
  apple-sdk_15,
  vulkan-tools,
  vulkan-headers,
  vulkan-loader,
  spirv-headers,
  shaderc,
  ccache,

  versionCheckHook,
  writableTmpDirAsHomeHook,

  # passthru
  nixosTests,
  ollama,
  ollama-rocm,
  ollama-cuda,
  ollama-vulkan,

  config,
  # one of `[ null false "rocm" "cuda" "vulkan" ]`
  acceleration ? null,
}:

assert builtins.elem acceleration [
  null
  false
  "rocm"
  "cuda"
  "vulkan"
];

let
  validateFallback = lib.warnIf (config.rocmSupport && config.cudaSupport) (lib.concatStrings [
    "both `nixpkgs.config.rocmSupport` and `nixpkgs.config.cudaSupport` are enabled, "
    "but they are mutually exclusive; falling back to cpu"
  ]) (!(config.rocmSupport && config.cudaSupport));
  shouldEnable =
    mode: fallback: (acceleration == mode) || (fallback && acceleration == null && validateFallback);

  rocmRequested = shouldEnable "rocm" config.rocmSupport;
  cudaRequested = shouldEnable "cuda" config.cudaSupport;
  vulkanRequested = acceleration == "vulkan";

  enableRocm = rocmRequested && stdenv.hostPlatform.isLinux;
  enableCuda = cudaRequested && stdenv.hostPlatform.isLinux;
  enableVulkan = vulkanRequested && stdenv.hostPlatform.isLinux;

  rocmLibs = [
    rocmPackages.clr
    rocmPackages.hipblas-common
    rocmPackages.hipblas
    rocmPackages.rocblas
    rocmPackages.rocsolver
    rocmPackages.rocsparse
    rocmPackages.rocm-device-libs
    rocmPackages.rocm-smi
  ];
  rocmPath = buildEnv {
    name = "rocm-path";
    paths = rocmLibs;
  };

  cudaLibs = [
    cudaPackages.cuda_cudart
    cudaPackages.libcublas
    cudaPackages.cuda_cccl
  ];

  vulkanLibs = [
    vulkan-headers
    vulkan-loader
  ];

  # Extract the major version of CUDA. e.g. 11 12
  cudaMajorVersion = lib.versions.major cudaPackages.cuda_cudart.version;

  cudaToolkit = buildEnv {
    # ollama hardcodes the major version in the Makefile to support different variants.
    # - https://github.com/ollama/ollama/blob/v0.21.1/CMakePresets.json#L21-L47
    name = "cuda-merged-${cudaMajorVersion}";
    paths = map lib.getLib cudaLibs ++ [
      (lib.getOutput "static" cudaPackages.cuda_cudart)
      (lib.getBin (cudaPackages.cuda_nvcc.__spliced.buildHost or cudaPackages.cuda_nvcc))
    ];

    # cuda_cccl and cuda_cudart both have a LICENSE file in their output
    ignoreCollisions = true;
  };

  cudaPath = lib.removeSuffix "-${cudaMajorVersion}" cudaToolkit;

  # Since v0.30, llama.cpp is consumed via CMake FetchContent rather than
  # vendored in-tree. Pre-stage the pin (tracks upstream's
  # `LLAMA_CPP_VERSION` file) so the FetchContent step uses our copy
  # instead of trying to clone over the network in the sandbox.
  llamaCppSrc = fetchFromGitHub {
    owner = "ggml-org";
    repo = "llama.cpp";
    tag = "b9509";
    hash = "sha256-bO1ucb/+vidj/EYzNCssotjte9NlVLdjC794jToNNeM=";
  };

  wrapperOptions = [
    # ollama embeds llama-cpp binaries which actually run the ai models
    # these llama-cpp binaries are unaffected by the ollama binary's DT_RUNPATH
    # LD_LIBRARY_PATH is temporarily required to use the gpu
    # until these llama-cpp binaries can have their runpath patched
    "--suffix LD_LIBRARY_PATH : '${addDriverRunpath.driverLink}/lib'"
  ]
  ++ lib.optionals enableRocm [
    "--suffix LD_LIBRARY_PATH : '${rocmPath}/lib'"
    "--set-default HIP_PATH '${rocmPath}'"
  ]
  ++ lib.optionals enableCuda [
    "--suffix LD_LIBRARY_PATH : '${lib.makeLibraryPath (map lib.getLib cudaLibs)}'"
  ]
  ++ lib.optionals enableVulkan [
    "--suffix LD_LIBRARY_PATH : '${lib.makeLibraryPath (map lib.getLib vulkanLibs)}'"
    "--set-default OLLAMA_VULKAN '1'"
  ];
  wrapperArgs = builtins.concatStringsSep " " wrapperOptions;

  goBuild =
    if enableCuda then
      buildGoModule.override { stdenv = cudaPackages.backendStdenv; }
    else if enableRocm then
      buildGoModule.override { inherit (rocmPackages) stdenv; }
    else if enableVulkan then
      buildGoModule.override { inherit (vulkan-tools) stdenv; }
    else
      buildGoModule;
  inherit (lib) licenses platforms maintainers;
in
goBuild (finalAttrs: {
  pname = "ollama";
  version = "0.30.7";

  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pS6Wd//g+Q1Oqw32+mr2h5ag7C2HNwf/8ZVrTKOvdWE=";
  };

  vendorHash = "sha256-lZdGzGb9xRjTm1Rm7/wHjqM490gLznLEndmb4mNbCX0=";
  proxyVendor = true;

  env =
    lib.optionalAttrs enableRocm {
      ROCM_PATH = rocmPath;
      CLBlast_DIR = "${clblast}/lib/cmake/CLBlast";
      HIP_PATH = rocmPath;
      CFLAGS = "-Wno-c++17-extensions -I${rocmPath}/include";
      CXXFLAGS = "-Wno-c++17-extensions -I${rocmPath}/include";
    }
    // lib.optionalAttrs enableCuda { CUDA_PATH = cudaPath; }
    // lib.optionalAttrs enableVulkan { VULKAN_SDK = shaderc.bin; };

  nativeBuildInputs = [
    cmake
    gitMinimal
  ]
  ++ lib.optionals enableRocm (
    rocmLibs
    ++ [
      rocmPackages.llvm.bintools
    ]
  )
  ++ lib.optionals enableCuda [ cudaPackages.cuda_nvcc ]
  ++ lib.optionals (enableRocm || enableCuda) [
    makeBinaryWrapper
    autoAddDriverRunpath
  ]
  ++ lib.optionals enableVulkan [
    ccache
    # ggml-vulkan/CMakeLists.txt does `find_package(SPIRV-Headers REQUIRED)`
    # at configure time (it builds shader code into the vulkan backend).
    # Header-only — nativeBuildInputs is the right slot.
    spirv-headers
  ];

  buildInputs =
    lib.optionals enableRocm (rocmLibs ++ [ libdrm ])
    ++ lib.optionals enableCuda cudaLibs
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ]
    ++ lib.optionals enableVulkan vulkanLibs;

  # replace inaccurate version number with actual release version
  postPatch = ''
    substituteInPlace version/version.go \
      --replace-fail 0.0.0 '${finalAttrs.version}'

    # cmd/launch/*_test.go are integration tests for user-facing CLI
    # launchers (claude, qwen, cline, codex, kimi, droid, openclaw, hermes,
    # …) that install the target binary via npm and then exec it on PATH.
    # Both prerequisites are unavailable in the nix sandbox, so the launch
    # subpackage's tests can't pass here. Drop them.
    rm cmd/launch/*_test.go

    rm -r app

    # Pre-stage llama.cpp for the FetchContent step and apply Ollama's
    # compat patch. When FETCHCONTENT_SOURCE_DIR_LLAMA_CPP is set, neither
    # `cmake/local.cmake` nor `llama/server/CMakeLists.txt` auto-applies
    # the patch (the parent's ExternalProject_Add passes
    # OLLAMA_LLAMA_CPP_SKIP_COMPAT_PATCH=ON to the child build) — the
    # caller has to. The apply-patch.cmake script is idempotent so this
    # is safe to re-run.
    cp -r ${llamaCppSrc} $TMPDIR/llama-cpp-src
    chmod -R +w $TMPDIR/llama-cpp-src
    ( cd $TMPDIR/llama-cpp-src && \
      cmake -DPATCH_DIR=$NIX_BUILD_TOP/source/llama/compat \
        -P $NIX_BUILD_TOP/source/llama/compat/apply-patch.cmake )
  '';

  overrideModAttrs = _: _: {
    # don't run llama.cpp build in the module fetch phase
    preBuild = "";
  };

  preBuild =
    let
      removeSMPrefix =
        str:
        let
          matched = builtins.match "sm_(.*)" str;
        in
        if matched == null then str else builtins.head matched;

      cudaArchitectures = builtins.concatStringsSep ";" (map removeSMPrefix cudaArches);
      rocmTargets = builtins.concatStringsSep ";" rocmGpuTargets;

      # Since 0.30, Ollama splits the llama.cpp build into per-accelerator
      # "runners" gated by OLLAMA_LLAMA_BACKENDS. Without setting it the
      # build silently produces only the CPU runner — ollama-cuda would
      # ship without `libggml-cuda.so` and fall back to CPU at runtime.
      # The accepted values map to cmake/local.cmake's elseif chain
      # (cuda_v12 / cuda_v13 / rocm_v7_1 / rocm_v7_2 / vulkan / cuda_jetpack*).
      rocmMajorVersion = lib.versions.major rocmPackages.clr.version;
      rocmMinorVersion = lib.versions.minor rocmPackages.clr.version;
      llamaBackend =
        if enableCuda then
          "cuda_v${cudaMajorVersion}"
        else if enableRocm then
          "rocm_v${rocmMajorVersion}_${rocmMinorVersion}"
        else if enableVulkan then
          "vulkan"
        else
          "";

      cmakeFlagsCudaArchitectures = lib.optionalString enableCuda "-DCMAKE_CUDA_ARCHITECTURES='${cudaArchitectures}'";
      cmakeFlagsRocmTargets = lib.optionalString enableRocm "-DAMDGPU_TARGETS='${rocmTargets}'";
      cmakeFlagsBackend = lib.optionalString (
        llamaBackend != ""
      ) "-DOLLAMA_LLAMA_BACKENDS=${llamaBackend}";

    in
    ''
      ${lib.optionalString enableVulkan ''
        # Ollama builds each per-accelerator llama.cpp runner via
        # cmake/local.cmake's ExternalProject_Add(ollama-llama-server-vulkan …).
        # Two things need to cross the parent → child boundary:
        #
        # 1. The SPIRV-Headers cmake config — so `find_package(SPIRV-Headers
        #    REQUIRED)` at ggml-vulkan/CMakeLists.txt:14 succeeds in the
        #    child. CMAKE_PREFIX_PATH as a flag wouldn't propagate; as env
        #    var it does.
        # 2. The SPIRV-Headers include directory in the compile env. The
        #    ggml-vulkan target's `target_link_libraries(... Vulkan::Vulkan)`
        #    notably does NOT link `SPIRV-Headers::SPIRV-Headers`, so the
        #    interface include directory the cmake config exports never
        #    flows into the compile commands — even though the find_package
        #    call succeeded. `#include <spirv/unified1/spirv.hpp>` then
        #    fails at compile time. Patching upstream's CMakeLists for
        #    one missing link line is fragile across llama.cpp pins;
        #    NIX_CFLAGS_COMPILE forces the include path globally and
        #    survives version bumps.
        export CMAKE_PREFIX_PATH="${spirv-headers}''${CMAKE_PREFIX_PATH:+:$CMAKE_PREFIX_PATH}"
        export NIX_CFLAGS_COMPILE="-isystem ${spirv-headers}/include $NIX_CFLAGS_COMPILE"
      ''}
      cmake -B build \
        -DCMAKE_SKIP_BUILD_RPATH=ON \
        -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
        -DFETCHCONTENT_SOURCE_DIR_LLAMA_CPP="$TMPDIR/llama-cpp-src" \
        -DOLLAMA_MLX_BACKENDS="" \
        ${cmakeFlagsCudaArchitectures} \
        ${cmakeFlagsRocmTargets} \
        ${cmakeFlagsBackend}

      cmake --build build -j $NIX_BUILD_CORES
    '';

  # The llama.cpp sub-build is driven by ExternalProject_Add and does
  # not inherit the parent's CMAKE_SKIP_BUILD_RPATH setting, so its
  # `.so` payloads end up with build-dir entries in RPATH. Drop them
  # before the forbidden-references check. $ORIGIN is preserved
  # unconditionally; only absolute /nix/store entries are kept.
  # ELF-only (patchelf doesn't know Mach-O); darwin builds Mach-O dylibs
  # that don't carry the build-dir RPATH problem in the first place.
  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    find $out/lib/ollama -type f \( -name '*.so' -o -name '*.so.*' \) \
      -exec patchelf --shrink-rpath --allowed-rpath-prefixes /nix/store {} +
  '';

  # ollama looks for acceleration libs in ../lib/ollama/ (now also for CPU-only with arch specific optimizations)
  # https://github.com/ollama/ollama/blob/v0.21.1/docs/development.md#library-detection
  postInstall = ''
    mkdir -p $out/lib
    cp -r build/lib/ollama $out/lib/
  '';

  postFixup =
    # expose runtime libraries necessary to use the gpu
    lib.optionalString (enableRocm || enableCuda) ''
      wrapProgram "$out/bin/ollama" ${wrapperArgs}
    '';

  ldflags = [
    "-X=github.com/ollama/ollama/version.Version=${finalAttrs.version}"
    "-X=github.com/ollama/ollama/server.mode=release"
  ];

  __darwinAllowLocalNetworking = true;

  # required for github.com/ollama/ollama/detect's tests
  sandboxProfile = lib.optionalString stdenv.hostPlatform.isDarwin ''
    (allow file-read* (subpath "/System/Library/Extensions"))
    (allow iokit-open (iokit-user-client-class "AGXDeviceUserClient"))
  '';

  checkFlags =
    let
      # Skip tests that require network access
      skippedTests = [
        "TestPushHandler/unauthorized_push" # Writes to $HOME, see https://github.com/ollama/ollama/pull/12307#pullrequestreview-3249128660
        "TestPiRun_InstallAndWebSearchLifecycle" # Requires network access to install npm packages
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = "HOME";

  passthru = {
    tests = {
      inherit ollama;
    }
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      inherit ollama-rocm ollama-cuda ollama-vulkan;
      service = nixosTests.ollama;
      service-cuda = nixosTests.ollama-cuda;
      service-rocm = nixosTests.ollama-rocm;
      service-vulkan = nixosTests.ollama-vulkan;
    };
  }
  // lib.optionalAttrs (!enableRocm && !enableCuda) { updateScript = nix-update-script { }; };

  meta = {
    description =
      "Get up and running with large language models locally"
      + lib.optionalString rocmRequested ", using ROCm for AMD GPU acceleration"
      + lib.optionalString cudaRequested ", using CUDA for NVIDIA GPU acceleration"
      + lib.optionalString vulkanRequested ", using Vulkan for generic GPU acceleration";
    homepage = "https://github.com/ollama/ollama";
    changelog = "https://github.com/ollama/ollama/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    platforms =
      if (rocmRequested || cudaRequested || vulkanRequested) then platforms.linux else platforms.unix;
    mainProgram = "ollama";
    maintainers = with maintainers; [
      prusnak
    ];
  };
})
