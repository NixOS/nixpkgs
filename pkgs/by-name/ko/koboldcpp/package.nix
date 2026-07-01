{
  lib,
  buildEnv,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  python3Packages,
  tk,
  autoAddDriverRunpath,
  addDriverRunpath,

  koboldLiteSupport ? true,

  cudaPackages ? { },

  cublasSupport ? false,

  rocmSupport ? false,
  rocmPackages ? { },
  rocmGpuTargets ? rocmPackages.clr.localGpuTargets or rocmPackages.clr.gpuTargets,

  vulkanSupport ? false,
  vulkan-loader,
  shaderc,
  metalSupport ? false,
  nix-update-script,
}:

assert !(cublasSupport && rocmSupport);

let
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

  rocmBuildInputs = with rocmPackages; [
    clr
    hipblas
    rocblas
  ];

  rocmPath = buildEnv {
    name = "rocm-path";
    paths = rocmBuildInputs ++ [
      rocmPackages.clang
      rocmPackages.hipcc
      rocmPackages.rocm-device-libs
    ];
  };

  runtimePath = [ tk ];

  wrapperArgs = lib.escapeShellArgs (
    [
      "--prefix"
      "PATH"
      ":"
      (lib.makeBinPath runtimePath)
    ]
    ++ libraryPathWrapperArgs
  );

  effectiveStdenv =
    if cublasSupport then
      cudaPackages.backendStdenv
    else if rocmSupport then
      rocmPackages.stdenv
    else
      stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "koboldcpp";
  version = "1.116.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "LostRuins";
    repo = "koboldcpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jElhMxi8FyvprlSWlc0PQa0NtLvBNZXY3vF/7YKZFv4=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    makeWrapper
    python3Packages.wrapPython
  ]
  ++ lib.optionals cublasSupport [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
  ]
  ++ lib.optionals vulkanSupport [ shaderc ];

  pythonInputs = builtins.attrValues { inherit (python3Packages) tkinter customtkinter packaging; };

  buildInputs = [
    tk
  ]
  ++ finalAttrs.pythonInputs
  ++ lib.optionals cublasSupport [
    cudaPackages.libcublas
    cudaPackages.cuda_cudart
    cudaPackages.cuda_cccl
  ]
  ++ lib.optionals rocmSupport rocmBuildInputs
  ++ lib.optionals vulkanSupport [
    vulkan-loader
  ];

  pythonPath = finalAttrs.pythonInputs;

  makeFlags = [
    "LLAMA_PORTABLE=1"
  ]
  ++ lib.optionals cublasSupport [
    "LLAMA_CUBLAS=1"
    "CUBLAS_FLAGS=-DGGML_USE_CUDA -DSD_USE_CUDA"
    "CUBLASLD_FLAGS=-L${lib.getOutput "stubs" cudaPackages.cuda_cudart}/lib/stubs -lcuda -lcublas -lcudart -lcublasLt -lpthread -ldl -lrt"
    "NVCCFLAGS=--forward-unknown-to-host-compiler -use_fast_math -extended-lambda -Wno-deprecated-gpu-targets -DKCPP_LIMIT_CUDA_MAX_ARCH=${cudaMaxArch} ${cudaPackages.flags.gencodeString}"
  ]
  ++ lib.optionals rocmSupport [
    "LLAMA_HIPBLAS=1"
    "ROCM_PATH=${rocmPath}"
    "HCC=${rocmPackages.clang}/bin/clang"
    "HCXX=${rocmPackages.clang}/bin/clang++"
    "GPU_TARGETS=${builtins.concatStringsSep " " rocmGpuTargets}"
  ]
  ++ lib.optionals vulkanSupport [ "LLAMA_VULKAN=1" ]
  ++ lib.optionals metalSupport [ "LLAMA_METAL=1" ];

  buildFlags = [
    "koboldcpp_default"
    "koboldcpp_failsafe"
    "koboldcpp_noavx2"
  ]
  ++ lib.optionals cublasSupport [ "koboldcpp_cublas" ]
  ++ lib.optionals rocmSupport [ "koboldcpp_hipblas" ]
  ++ lib.optionals vulkanSupport [
    "koboldcpp_vulkan"
    "koboldcpp_vulkan_failsafe"
    "koboldcpp_vulkan_noavx2"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"

    install -Dm755 koboldcpp.py "$out/bin/koboldcpp.unwrapped"
    cp *.so "$out/bin"
    cp -r embd_res "$out/bin"

    ${lib.optionalString metalSupport ''
      cp *.metal "$out/bin"
    ''}

    ${lib.optionalString (!koboldLiteSupport) ''
      rm "$out/bin/embd_res/kcpp_docs.embd"
      rm "$out/bin/embd_res/klite.embd"
    ''}

    runHook postInstall
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/bin" "''${pythonPath[*]}"
    makeWrapper "$out/bin/koboldcpp.unwrapped" "$out/bin/koboldcpp" \
      ${wrapperArgs}
  '';

  requiredSystemFeatures = lib.optionals rocmSupport [ "big-parallel" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/LostRuins/koboldcpp/releases/tag/v${finalAttrs.version}";
    description = "Way to run various GGML and GGUF models";
    homepage = "https://github.com/LostRuins/koboldcpp";
    license = with lib.licenses; [ agpl3Only ] ++ lib.optional cublasSupport nvidiaCudaRedist;
    mainProgram = "koboldcpp";
    maintainers = with lib.maintainers; [
      maxstrid
      FlameFlag
    ];
    platforms = if metalSupport then lib.platforms.darwin else lib.platforms.unix;
    badPlatforms = lib.optionals (cublasSupport || rocmSupport) lib.platforms.darwin;
  };
})
