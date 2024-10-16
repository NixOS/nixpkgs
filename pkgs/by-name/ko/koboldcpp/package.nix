{
  lib,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  gitUpdater,
  python3Packages,
  tk,
  addDriverRunpath,

  darwin,
  overrideSDK,

  koboldLiteSupport ? true,

  config,
  cudaPackages ? { },

  openblasSupport ? !stdenv.hostPlatform.isDarwin,
  openblas,

  cublasSupport ? config.cudaSupport,
  # You can find a full list here: https://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/
  # For example if you're on an GTX 1080 that means you're using "Pascal" and you need to pass "sm_60"
  cudaArches ? cudaPackages.cudaFlags.realArches or [ ],

  clblastSupport ? stdenv.hostPlatform.isLinux,
  clblast,
  ocl-icd,

  vulkanSupport ? true,
  vulkan-loader,
  metalSupport ? stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64,
}:

let
  makeBool = option: bool: (if bool then "${option}=1" else "");

  libraryPathWrapperArgs = lib.optionalString config.cudaSupport ''
    --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ addDriverRunpath.driverLink ]}"
  '';

  stdenv' =
    if stdenv.hostPlatform.isDarwin then
      overrideSDK stdenv {
        darwinMinVersion = "10.15";
        darwinSdkVersion = "12.3";
      }
    else
      stdenv;

  effectiveStdenv = if cublasSupport then cudaPackages.backendStdenv else stdenv';
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "koboldcpp";
  version = "1.76";

  src = fetchFromGitHub {
    owner = "LostRuins";
    repo = "koboldcpp";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-0zV9aZIfNnbV/K6xYUp+ucdJvdEfuGdKgE/Q7vcBopQ=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    makeWrapper
    python3Packages.wrapPython
  ];

  pythonInputs = builtins.attrValues { inherit (python3Packages) tkinter customtkinter packaging; };

  buildInputs =
    [ tk ]
    ++ finalAttrs.pythonInputs
    ++ lib.optionals effectiveStdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Accelerate
      darwin.apple_sdk.frameworks.CoreVideo
      darwin.apple_sdk.frameworks.CoreGraphics
      darwin.apple_sdk.frameworks.CoreServices
    ]
    ++ lib.optionals metalSupport [
      darwin.apple_sdk.frameworks.MetalKit
      darwin.apple_sdk.frameworks.Foundation
      darwin.apple_sdk.frameworks.MetalPerformanceShaders
    ]
    ++ lib.optionals openblasSupport [ openblas ]
    ++ lib.optionals cublasSupport [
      cudaPackages.libcublas
      cudaPackages.cuda_nvcc
      cudaPackages.cuda_cudart
      cudaPackages.cuda_cccl
    ]
    ++ lib.optionals clblastSupport [
      clblast
      ocl-icd
    ]
    ++ lib.optionals vulkanSupport [ vulkan-loader ];

  pythonPath = finalAttrs.pythonInputs;

  darwinLdFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-F${darwin.apple_sdk.frameworks.CoreServices}/Library/Frameworks"
    "-F${darwin.apple_sdk.frameworks.Accelerate}/Library/Frameworks"
    "-framework CoreServices"
    "-framework Accelerate"
  ];
  metalLdFlags = lib.optionals metalSupport [
    "-F${darwin.apple_sdk.frameworks.Foundation}/Library/Frameworks"
    "-F${darwin.apple_sdk.frameworks.Metal}/Library/Frameworks"
    "-framework Foundation"
    "-framework Metal"
  ];

  env.NIX_LDFLAGS = lib.concatStringsSep " " (finalAttrs.darwinLdFlags ++ finalAttrs.metalLdFlags);

  makeFlags = [
    (makeBool "LLAMA_OPENBLAS" openblasSupport)
    (makeBool "LLAMA_CUBLAS" cublasSupport)
    (makeBool "LLAMA_CLBLAST" clblastSupport)
    (makeBool "LLAMA_VULKAN" vulkanSupport)
    (makeBool "LLAMA_METAL" metalSupport)
    (lib.optionals cublasSupport "CUDA_DOCKER_ARCH=${builtins.head cudaArches}")
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"

    install -Dm755 koboldcpp.py "$out/bin/koboldcpp.unwrapped"
    cp *.so "$out/bin"
    cp *.embd "$out/bin"

    ${lib.optionalString (!koboldLiteSupport) ''
      rm "$out/bin/kcpp_docs.embd"
      rm "$out/bin/klite.embd"
    ''}

    runHook postInstall
  '';

  # Remove an unused argument, mainly intended for Darwin to reduce warnings
  postPatch = ''
    substituteInPlace Makefile \
      --replace-warn " -s " " "
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/bin" "$pythonPath"
    makeWrapper "$out/bin/koboldcpp.unwrapped" "$out/bin/koboldcpp" \
      --prefix PATH : ${lib.makeBinPath [ tk ]} ${libraryPathWrapperArgs}
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    changelog = "https://github.com/LostRuins/koboldcpp/releases/tag/v${finalAttrs.version}";
    description = "Way to run various GGML and GGUF models";
    homepage = "https://github.com/LostRuins/koboldcpp";
    license = lib.licenses.agpl3Only;
    mainProgram = "koboldcpp";
    maintainers = with lib.maintainers; [
      maxstrid
      donteatoreo
    ];
    platforms = lib.platforms.unix;
  };
})
