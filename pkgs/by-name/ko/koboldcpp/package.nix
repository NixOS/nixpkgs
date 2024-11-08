{
  lib,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  gitUpdater,
  python3Packages,
  tk,
  addDriverRunpath,

  apple-sdk_12,

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
  version = "1.78";

  src = fetchFromGitHub {
    owner = "LostRuins";
    repo = "koboldcpp";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-6RvodNWO/IVGlKxC/zt0itYDzymhk+hEBpbmQ1jHigU=";
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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_12 ]
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
      donteatoreo
    ];
    platforms = lib.platforms.unix;
  };
})
