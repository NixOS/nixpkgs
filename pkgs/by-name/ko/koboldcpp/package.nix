{
  lib,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  python3Packages,
  tk,
  addDriverRunpath,

  apple-sdk_13,

  koboldLiteSupport ? true,

  config,
  cudaPackages ? { },

  cublasSupport ? config.cudaSupport,
  # You can find a full list here: https://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/
  # For example if you're on an RTX 3060 that means you're using "Ampere" and you need to pass "sm_86"
  cudaArches ? cudaPackages.flags.realArches or [ ],

  clblastSupport ? stdenv.hostPlatform.isLinux,
  clblast,
  ocl-icd,

  vulkanSupport ? true,
  vulkan-loader,
  shaderc,
  metalSupport ? stdenv.hostPlatform.isDarwin,
  nix-update-script,
}:

let
  makeBool = option: bool: (if bool then "${option}=1" else "");

  libraryPathWrapperArgs = lib.optionalString config.cudaSupport ''
    --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ addDriverRunpath.driverLink ]}"
  '';

  effectiveStdenv = if cublasSupport then cudaPackages.backendStdenv else stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "koboldcpp";
  version = "1.99.4";

  src = fetchFromGitHub {
    owner = "LostRuins";
    repo = "koboldcpp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ilBrTMtY6bhns2GcwDckGq4+RqzgzBCg0HJJ4QUx8Co=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    makeWrapper
    python3Packages.wrapPython
  ];

  pythonInputs = builtins.attrValues { inherit (python3Packages) tkinter customtkinter packaging; };

  buildInputs = [
    tk
  ]
  ++ finalAttrs.pythonInputs
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_13 ]
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
  ++ lib.optionals vulkanSupport [
    vulkan-loader
    shaderc
  ];

  pythonPath = finalAttrs.pythonInputs;

  makeFlags = [
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

    ${lib.optionalString metalSupport ''
      cp *.metal "$out/bin"
    ''}

    ${lib.optionalString (!koboldLiteSupport) ''
      rm "$out/bin/kcpp_docs.embd"
      rm "$out/bin/klite.embd"
    ''}

    runHook postInstall
  '';

  postFixup = ''
    wrapPythonProgramsIn "$out/bin" "$pythonPath"
    makeWrapper "$out/bin/koboldcpp.unwrapped" "$out/bin/koboldcpp" \
      --prefix PATH : ${lib.makeBinPath [ tk ]} ${libraryPathWrapperArgs}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/LostRuins/koboldcpp/releases/tag/v${finalAttrs.version}";
    description = "Way to run various GGML and GGUF models";
    homepage = "https://github.com/LostRuins/koboldcpp";
    license = lib.licenses.agpl3Only;
    mainProgram = "koboldcpp";
    maintainers = with lib.maintainers; [
      maxstrid
      FlameFlag
    ];
    platforms = lib.platforms.unix;
  };
})
