{
  lib,
  buildEnv,
  buildPackages,
  cacert,
  cloudflared,
  copyDesktopItems,
  coreutils,
  curl,
  fetchFromGitHub,
  icoutils,
  makeDesktopItem,
  stdenv,
  runtimeShell,
  replaceVars,
  python3Packages,
  autoAddDriverRunpath,

  koboldLiteSupport ? true,

  config,
  cudaPackages ? { },

  cublasSupport ? config.cudaSupport,

  rocmSupport ? config.rocmSupport,
  rocmPackages ? { },
  rocmGpuTargets ? rocmPackages.clr.localGpuTargets or rocmPackages.clr.gpuTargets or [ ],

  vulkanSupport ? false,
  vulkan-loader,
  shaderc,
  vulkan-tools,
  metalSupport ? false,
  nix-update-script,
  versionCheckHook,
  xdg-utils,
  xterm,
}:

assert lib.assertMsg (!(cublasSupport && rocmSupport)) ''
  koboldcpp: CUDA (cublasSupport) and ROCm (rocmSupport) are mutually exclusive
'';

let
  platformMakeFlags = [
    "UNAME_S=${stdenv.hostPlatform.uname.system}"
    "UNAME_M=${stdenv.hostPlatform.uname.processor}"
    "UNAME_P=${stdenv.hostPlatform.uname.processor}"
    "UNAME_O=${stdenv.hostPlatform.uname.system}"
    # Do not specialize portable binaries for the build machine's POWER CPU
    "POWER9_M="
    "LLAMA_PORTABLE=1"
  ];

  cudaMaxArch =
    let
      cudaArchitectures = map (
        capability:
        lib.toInt (cudaPackages.flags.dropDots (lib.removeSuffix "f" (lib.removeSuffix "a" capability)))
      ) cudaPackages.flags.cudaCapabilities;
    in
    # KCPP_LIMIT_CUDA_MAX_ARCH uses CUDA's numeric architecture encoding
    # (8.9 -> 89 -> 890). Take the numeric maximum because the capability
    # list need not be sorted, then convert it to a Makefile flag value
    toString (10 * lib.foldl' lib.max 0 cudaArchitectures);

  libraryPathWrapperArgs = lib.optionals (rocmSupport && stdenv.hostPlatform.isLinux) [
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    "${rocmPath}/lib"
    "--set-default"
    "HIP_PATH"
    "${rocmPath}"
    "--set-default"
    "ROCM_PATH"
    "${rocmPath}"
  ];

  # The Makefile expects a single ROCM_PATH that provides hipconfig, hipcc,
  # amdhip64, hipblas, and rocblas. clr ships hipconfig plus the HIP/LLVM
  # compiler, but hipconfig is wrapped with ROCM_PATH=clr so `hipconfig -C`
  # never emits hipblas/rocblas/hipblas-common include flags
  rocmBuildInputs = with rocmPackages; [
    clr
    hipblas
    hipblas-common
    rocblas
  ];

  rocmPath = buildEnv {
    name = "rocm-path";
    paths = rocmBuildInputs;
  };

  runtimePath = [
    cloudflared
    curl
  ]
  ++ lib.optionals rocmSupport [ rocmPackages.rocminfo ]
  ++ lib.optionals vulkanSupport [
    vulkan-tools
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    xdg-utils
    xterm
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath runtimePath)
    "--set-default"
    "SSL_CERT_FILE"
    "${cacert}/etc/ssl/certs/ca-bundle.crt"
  ]
  ++ libraryPathWrapperArgs;

  libraries = [
    "koboldcpp_default"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isx86 || metalSupport) [
    "koboldcpp_failsafe"
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86 [
    "koboldcpp_noavx2"
  ]
  ++ lib.optionals cublasSupport [ "koboldcpp_cublas" ]
  ++ lib.optionals rocmSupport [ "koboldcpp_hipblas" ]
  ++ lib.optionals vulkanSupport [ "koboldcpp_vulkan" ]
  ++ lib.optionals (vulkanSupport && stdenv.hostPlatform.isx86) [
    "koboldcpp_vulkan_failsafe"
    "koboldcpp_vulkan_noavx2"
  ];

  effectiveStdenv =
    if cublasSupport then
      cudaPackages.backendStdenv
    else if rocmSupport then
      rocmPackages.stdenv
    else
      stdenv;

  metalFailsafe =
    { src, version }:
    stdenv.mkDerivation {
      pname = "koboldcpp-macos-failsafe";
      inherit src version;

      __structuredAttrs = true;
      strictDeps = true;

      enableParallelBuilding = true;
      makeFlags = platformMakeFlags;
      buildFlags = [ "koboldcpp_macos_failsafe" ];

      installPhase = ''
        runHook preInstall

        install -Dm755 koboldcpp_macos_failsafe.so \
          "$out/lib/koboldcpp_failsafe.so"

        runHook postInstall
      '';
    };

  builtLibraries = if metalSupport then lib.remove "koboldcpp_failsafe" libraries else libraries;

  allBackendLibraries = [
    "koboldcpp_default"
    "koboldcpp_failsafe"
    "koboldcpp_noavx2"
    "koboldcpp_cublas"
    "koboldcpp_hipblas"
    "koboldcpp_vulkan"
    "koboldcpp_vulkan_failsafe"
    "koboldcpp_vulkan_noavx2"
  ];

  # libcuda is supplied by the host driver and is unavailable in the
  # build sandbox. Every other installed backend can be load-tested
  # hermetically
  loadableLibraries = lib.remove "koboldcpp_cublas" libraries;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "koboldcpp";
  version = "1.122";

  src = fetchFromGitHub {
    owner = "LostRuins";
    repo = "koboldcpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9NW6cnlNgxRMvhyEE1Icydo5Mxii5rjfoUMNa7YZg6A=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  patches = [
    (replaceVars ./nixos-runtime-paths.patch {
      shell = runtimeShell;
      cat = lib.getExe' coreutils "cat";
    })
  ];

  postPatch = lib.concatStringsSep "\n" [
    ''
      substituteInPlace kcpp_agent.py \
        --replace-fail 'shutil.which("sh")' '"${runtimeShell}"'
    ''
    (lib.optionalString vulkanSupport ''
      # Shader generators run on the build platform and need no target libraries
      ${lib.concatMapStringsSep "\n"
        (define: ''
          substituteInPlace Makefile \
            --replace-fail '$(CXX) $(CXXFLAGS) $(${define}) $(filter-out %.h,$^) -o $@ $(LDFLAGS)' \
              '${lib.getExe' buildPackages.stdenv.cc "c++"} -std=c++17 -O3 -pthread $(${define}) $(filter-out %.h,$^) -o $@'
        '')
        [
          "VKGEN_NOEXT_ADD"
          "VKGEN_NOEXT_FORCE"
        ]
      }
    '')
    # Prefer nixpkgs shaderc's glslc over the bundled binary
    ''
      rm -f glslc-linux
    ''
  ];
  enableParallelBuilding = true;

  nativeBuildInputs = [
    copyDesktopItems
    icoutils
    python3Packages.wrapPython
  ]
  ++ lib.optionals cublasSupport [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
  ]
  ++ lib.optionals rocmSupport [ rocmPackages.clr ]
  ++ lib.optionals vulkanSupport [ shaderc ];

  pythonPath = builtins.attrValues {
    inherit (python3Packages)
      customtkinter
      darkdetect
      jinja2
      psutil
      tkinter
      ;
  };

  buildInputs =
    finalAttrs.pythonPath
    ++ lib.optionals cublasSupport [
      cudaPackages.libcublas
      cudaPackages.cuda_cudart
      cudaPackages.cccl
    ]
    ++ lib.optionals rocmSupport rocmBuildInputs
    ++ lib.optionals vulkanSupport [
      vulkan-loader
    ];

  inherit makeWrapperArgs;

  env =
    lib.optionalAttrs rocmSupport {
      # Keep this as an environment variable so the Makefile can append
      # its required HIP defines and hipconfig flags
      HIPFLAGS = "-I${rocmPath}/include";
    }
    // lib.optionalAttrs vulkanSupport {
      # The shader generator prefers bundled glslc-linux when this is set
      LLAMA_USE_BUNDLED_GLSLC = "";
    };

  makeFlags =
    platformMakeFlags
    ++ lib.optionals cublasSupport [
      "LLAMA_CUBLAS=1"
      "CUBLAS_FLAGS=-DGGML_USE_CUDA"
      "CUBLASLD_FLAGS=-L${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs -lcuda -lcublas -lcudart -lcublasLt -lpthread -ldl -lrt"
      "NVCCFLAGS=--forward-unknown-to-host-compiler -use_fast_math -extended-lambda -Wno-deprecated-gpu-targets -DKCPP_LIMIT_CUDA_MAX_ARCH=${cudaMaxArch} ${cudaPackages.flags.gencodeString}"
    ]
    ++ lib.optionals rocmSupport [
      "LLAMA_HIPBLAS=1"
      "ROCM_PATH=${rocmPath}"
      "HCC=${rocmPath}/bin/hipcc"
      "HCXX=${rocmPath}/bin/hipcc"
      "GPU_TARGETS=${builtins.concatStringsSep " " rocmGpuTargets}"
    ]
    ++ lib.optionals vulkanSupport [
      "LLAMA_VULKAN=1"
      "LLAMA_USE_BUNDLED_GLSLC="
    ]
    ++ lib.optionals metalSupport [ "LLAMA_METAL=1" ];

  buildFlags = builtLibraries;

  desktopItems = [
    (makeDesktopItem {
      name = "koboldcpp";
      desktopName = "KoboldCpp (Launcher)";
      comment = "Run GGML and GGUF models with the KoboldAI interface";
      icon = "koboldcpp";
      exec = "koboldcpp";
      categories = [
        "Utility"
        "TextTools"
      ];
      keywords = [
        "AI"
        "GGML"
        "GGUF"
        "KoboldAI"
        "LLM"
      ];
      startupNotify = true;
      terminal = true;
    })
  ];

  installPhase = lib.concatStringsSep "\n" [
    ''
      runHook preInstall

      installDir="$out/libexec/koboldcpp"
      mkdir -p "$installDir" "$out/bin"

      install -Dm755 koboldcpp.py "$installDir/koboldcpp"
      install -m644 json_to_gbnf.py kcpp_agent.py -t "$installDir"
      install -Dm755 ${lib.escapeShellArgs (map (library: "${library}.so") builtLibraries)} "$installDir"
      cp -r --no-preserve=mode embd_res kcpp_adapters -t "$installDir"
    ''

    # Install the project licenses and icon alongside the generated desktop
    # item
    ''
      install -Dm644 LICENSE.md MIT_LICENSE_GGML_SDCPP_LLAMACPP_ONLY.md \
        -t "$out/share/licenses/koboldcpp"
      mkdir -p "$out/share/icons/hicolor/64x64/apps"
      icotool --extract --index 1 \
        --output "$out/share/icons/hicolor/64x64/apps/koboldcpp.png" niko.ico
    ''

    (lib.optionalString metalSupport ''
      install -Dm755 ${
        metalFailsafe { inherit (finalAttrs) src version; }
      }/lib/koboldcpp_failsafe.so "$installDir"
      cp -r --no-preserve=mode kernels "$installDir"
    '')

    (lib.optionalString (!koboldLiteSupport) ''
      rm "$installDir/embd_res/kcpp_docs.embd"
      rm "$installDir/embd_res/klite.embd"
    '')

    ''
      runHook postInstall
    ''
  ];

  postFixup = ''
    wrapPythonProgramsIn "$out/libexec/koboldcpp" "''${pythonPath[*]}"
    ln -s ../libexec/koboldcpp/koboldcpp "$out/bin/koboldcpp"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = effectiveStdenv.buildPlatform.canExecute effectiveStdenv.hostPlatform;
  versionCheckProgramArg = "--version";

  postInstallCheck = ''
    # Exercise CLI parsing separately from the resource checks
    helpOutput="$("$out/bin/koboldcpp" --help)"
    echo "$helpOutput" | grep -F -- '--usecuda'
    echo "$helpOutput" | grep -F -- '--usevulkan'
    echo "$helpOutput" | grep -F -- '--gpulayers'

    # Check packaged runtime resources and the standalone JSON converter
    installDir="$out/libexec/koboldcpp"
    test -f "$installDir/json_to_gbnf.py"
    test -f "$installDir/embd_res/lcpp.gz.embd"
    test -f "$installDir/kcpp_adapters/AutoGuess.json"
    PYTHONPATH="$installDir" ${python3Packages.python.interpreter} -c \
      'from json_to_gbnf import SchemaConverter'

    # Check the desktop integration artifacts added by this variant-independent
    # package
    test -f "$out/share/applications/koboldcpp.desktop"
    test -f "$out/share/icons/hicolor/64x64/apps/koboldcpp.png"
    test -f "$out/share/licenses/koboldcpp/LICENSE.md"
    test -f "$out/share/licenses/koboldcpp/MIT_LICENSE_GGML_SDCPP_LLAMACPP_ONLY.md"

    # Verify every selected backend was installed
    ${lib.concatMapStringsSep "\n" (name: ''
      test -f "$installDir/${name}.so"
    '') libraries}

    # Load every backend whose driver dependencies are available in the sandbox
    ${lib.concatMapStringsSep "\n" (name: ''
      ${python3Packages.python.interpreter} -c \
        'import ctypes, sys; ctypes.CDLL(sys.argv[1])' \
        "$installDir/${name}.so"
    '') loadableLibraries}

    # Reject backend libraries that the selected variant should not contain
    ${lib.concatMapStringsSep "\n" (name: ''
      test ! -e "$installDir/${name}.so"
    '') (lib.subtractLists libraries allBackendLibraries)}

    ${lib.optionalString metalSupport ''
      # Metal compiles these shader sources and their shared headers at runtime
      for resource in kernels/*; do
        test -f "$installDir/$resource"
      done
    ''}
  '';

  requiredSystemFeatures = lib.optionals rocmSupport [ "big-parallel" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/LostRuins/koboldcpp/releases/tag/v${finalAttrs.version}";
    description = "Easy-to-use AI text-generation software for GGML and GGUF models";
    homepage = "https://github.com/LostRuins/koboldcpp";
    license =
      with lib.licenses;
      [
        agpl3Only
        mit
      ]
      ++ lib.optional cublasSupport nvidiaCudaRedist;
    mainProgram = "koboldcpp";
    maintainers = with lib.maintainers; [
      _4evy
    ];
    platforms =
      if cublasSupport || rocmSupport then
        lib.platforms.linux
      else if metalSupport then
        lib.platforms.darwin
      else
        lib.platforms.unix;
    broken = metalSupport && !effectiveStdenv.hostPlatform.isDarwin;
  };
})
