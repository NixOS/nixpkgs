{
  lib,
  buildEnv,
  cacert,
  cloudflared,
  curl,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  python3Packages,
  tk,
  autoAddDriverRunpath,
  addDriverRunpath,

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
  xdg-utils,
  xterm,
}:

assert lib.assertMsg (!(cublasSupport && rocmSupport)) ''
  koboldcpp: CUDA (cublasSupport) and ROCm (rocmSupport) are mutually exclusive
'';

let
  version = "1.119";

  src = fetchFromGitHub {
    owner = "LostRuins";
    repo = "koboldcpp";
    tag = "v${version}";
    hash = "sha256-WJVbzh4BGLiQdd/rzqSe2Q9PGqMpsqmQNQf33INJkd8=";
  };

  cudaMaxArch =
    let
      cudaMaxCapability = lib.removeSuffix "a" (
        cudaPackages.flags.dropDots (lib.last cudaPackages.flags.cudaCapabilities)
      );
    in
    "${cudaMaxCapability}0";

  libraryPathWrapperArgs =
    lib.optionals (cublasSupport && stdenv.hostPlatform.isLinux) [
      "--prefix"
      "LD_LIBRARY_PATH"
      ":"
      (lib.makeLibraryPath [ addDriverRunpath.driverLink ])
    ]
    ++ lib.optionals (rocmSupport && stdenv.hostPlatform.isLinux) [
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

  # 1.119's Makefile expects a single ROCM_PATH that provides hipconfig,
  # hipcc, amdhip64, hipblas, and rocblas. clr ships hipconfig plus the
  # HIP/LLVM compiler, but hipconfig is wrapped with ROCM_PATH=clr so
  # `hipconfig -C` never emits hipblas/rocblas/hipblas-common include
  # flags
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
    tk
  ]
  ++ lib.optionals rocmSupport [ rocmPackages.clr ]
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
  ++ libraryPathWrapperArgs
  ++ lib.optionals metalSupport [
    "--set-default"
    "GGML_METAL_PATH_RESOURCES"
    "${placeholder "out"}/libexec/koboldcpp"
  ];

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

  metalFailsafe = stdenv.mkDerivation {
    pname = "koboldcpp-macos-failsafe";
    inherit src version;

    __structuredAttrs = true;
    strictDeps = true;

    enableParallelBuilding = true;
    makeFlags = [ "LLAMA_PORTABLE=1" ];
    buildFlags = [ "koboldcpp_macos_failsafe" ];

    installPhase = ''
      runHook preInstall

      install -Dm755 koboldcpp_macos_failsafe.so \
        "$out/lib/koboldcpp_failsafe.so"

      runHook postInstall
    '';
  };

  builtLibraries = if metalSupport then lib.remove "koboldcpp_failsafe" libraries else libraries;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "koboldcpp";
  inherit src version;

  __structuredAttrs = true;
  strictDeps = true;
  patches = [
    ./nixos-runtime-paths.patch
    ./ggml-fix-gfx9-apu-detection.patch
  ];

  postPatch = lib.concatStringsSep "\n" [
    ''
      substituteInPlace koboldcpp.py \
        --replace-fail '@shell@' '${effectiveStdenv.shell}'
    ''
    # Prefer nixpkgs shaderc's glslc; 1.119 otherwise picks the bundled binary
    ''
      rm -f glslc-linux
    ''
  ];
  enableParallelBuilding = true;

  nativeBuildInputs = [
    makeWrapper
    python3Packages.wrapPython
  ]
  ++ lib.optionals cublasSupport [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
  ]
  ++ lib.optionals rocmSupport [ rocmPackages.clr ]
  ++ lib.optionals vulkanSupport [ shaderc ];

  pythonInputs = builtins.attrValues {
    inherit (python3Packages)
      customtkinter
      darkdetect
      jinja2
      psutil
      tkinter
      ;
  };

  buildInputs = [
    tk
  ]
  ++ finalAttrs.pythonInputs
  ++ lib.optionals cublasSupport [
    cudaPackages.libcublas
    cudaPackages.cuda_cudart
    cudaPackages.cccl
  ]
  ++ lib.optionals rocmSupport rocmBuildInputs
  ++ lib.optionals vulkanSupport [
    vulkan-loader
  ];

  pythonPath = finalAttrs.pythonInputs;

  inherit makeWrapperArgs;

  env =
    lib.optionalAttrs rocmSupport {
      # Keep this as an environment variable so the Makefile can append
      # its required HIP defines and hipconfig flags
      HIPFLAGS = "-I${rocmPath}/include";
    }
    // lib.optionalAttrs vulkanSupport {
      # 1.119's vulkan-shaders-gen recipe prefers bundled glslc-linux when this is set
      LLAMA_USE_BUNDLED_GLSLC = "";
    };

  makeFlags = [
    "LLAMA_PORTABLE=1"
  ]
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

  installPhase = lib.concatStringsSep "\n" [
    ''
      runHook preInstall

      installDir="$out/libexec/koboldcpp"
      mkdir -p "$installDir" "$out/bin"

      install -Dm755 koboldcpp.py "$installDir/koboldcpp"
      install -Dm644 json_to_gbnf.py "$installDir/json_to_gbnf.py"
      install -Dm755 ${lib.escapeShellArgs (map (library: "${library}.so") builtLibraries)} "$installDir"
      cp -r --no-preserve=mode embd_res "$installDir"
      cp -r --no-preserve=mode kcpp_adapters "$installDir"
    ''

    (lib.optionalString metalSupport ''
      install -Dm755 ${metalFailsafe}/lib/koboldcpp_failsafe.so "$installDir"
      install -Dm644 *.metal "$installDir"
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
      ]
      ++ lib.optional cublasSupport nvidiaCudaRedist;
    mainProgram = "koboldcpp";
    maintainers = with lib.maintainers; [
      maxstrid
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
