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

  koboldLiteSupport ? true,

  config,
  cudaPackages ? { },

  openblasSupport ? !stdenv.isDarwin,
  openblas,

  cublasSupport ? config.cudaSupport,

  clblastSupport ? stdenv.isLinux,
  clblast,
  ocl-icd,

  vulkanSupport ? true,
  vulkan-loader,

  metalSupport ? stdenv.isDarwin && stdenv.isAarch64,

  # You can find a full list here: https://arnon.dk/matching-sm-architectures-arch-and-gencode-for-various-nvidia-cards/
  # For example if you're on an GTX 1080 that means you're using "Pascal" and you need to pass "sm_60"
  arches ? cudaPackages.cudaFlags.arches or [ ],

  # You can find list of x86_64 options here: https://gcc.gnu.org/onlinedocs/gcc/x86-Options.html
  # For ARM here: https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html
  # If you set "march" to "native", specify "mtune" as well; otherwise, it will be set to "generic". (credit to: https://lemire.me/blog/2018/07/25/it-is-more-complicated-than-i-thought-mtune-march-in-gcc/)
  march ? "",
  # Apple Silicon Chips (M1, M2, M3 and so on DO NOT use mtune)
  # For example, if you have an AMD Ryzen CPU, you will set "mtune" to "znver2"
  mtune ? "",
  mcpu ? "",
}:

let
  makeBool = option: bool: (if bool then "${option}=1" else "");

  makeWrapperArgs = lib.optionalString config.cudaSupport ''
    --prefix LD_LIBRARY_PATH: "${lib.makeLibraryPath [ addDriverRunpath.driverLink ]}"
  '';

  effectiveStdenv = if cublasSupport then cudaPackages.backendStdenv else stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "koboldcpp";
  version = "1.69.1";

  src = fetchFromGitHub {
    owner = "LostRuins";
    repo = "koboldcpp";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-808HyqrB9/cFJU7nq7Cm5Fm4OFPML4oQtnv0hystwAg=";
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
    ++ lib.optionals effectiveStdenv.isDarwin [
      darwin.apple_sdk_11_0.frameworks.Accelerate
      darwin.apple_sdk_11_0.frameworks.CoreVideo
      darwin.apple_sdk_11_0.frameworks.CoreGraphics
      darwin.apple_sdk_11_0.frameworks.CoreServices
    ]
    ++ lib.optionals metalSupport [
      darwin.apple_sdk_11_0.frameworks.MetalKit
      darwin.apple_sdk_11_0.frameworks.Foundation
      darwin.apple_sdk_11_0.frameworks.MetalPerformanceShaders
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

  darwinLdFlags = lib.optionals stdenv.isDarwin [
    "-F${darwin.apple_sdk_11_0.frameworks.CoreServices}/Library/Frameworks"
    "-F${darwin.apple_sdk_11_0.frameworks.Accelerate}/Library/Frameworks"
    "-framework CoreServices"
    "-framework Accelerate"
  ];
  metalLdFlags = lib.optionals metalSupport [
    "-F${darwin.apple_sdk_11_0.frameworks.Foundation}/Library/Frameworks"
    "-F${darwin.apple_sdk_11_0.frameworks.Metal}/Library/Frameworks"
    "-framework Foundation"
    "-framework Metal"
  ];

  env.NIX_LDFLAGS = lib.concatStringsSep " " (finalAttrs.darwinLdFlags ++ finalAttrs.metalLdFlags);

  env.NIX_CFLAGS_COMPILE = lib.concatStringsSep " " [
    (lib.optionalString (march != "") "-march=${march}")
    (lib.optionalString (mtune != "") "-mtune=${mtune}")
    (lib.optionalString (mcpu != "") "-mcpu=${mcpu}")
  ];

  makeFlags = [
    (makeBool "LLAMA_OPENBLAS" openblasSupport)
    (makeBool "LLAMA_CUBLAS" cublasSupport)
    (makeBool "LLAMA_CLBLAST" clblastSupport)
    (makeBool "LLAMA_VULKAN" vulkanSupport)
    (makeBool "LLAMA_METAL" metalSupport)
    (lib.optionalString cublasSupport "CUDA_DOCKER_ARCH=sm_${builtins.head arches}")
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
      --prefix PATH ${lib.makeBinPath [ tk ]} ${makeWrapperArgs}
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Way to run various GGML and GGUF models";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      maxstrid
      donteatoreo
    ];
    mainProgram = "koboldcpp";
    platforms = lib.platforms.unix;
  };
})
