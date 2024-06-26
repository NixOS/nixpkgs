{
  lib,
  fetchFromGitHub,
  stdenv,
  makeWrapper,
  gitUpdater,
  python311Packages,
  tk,

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

  # You can find list of x86_64 options here: https://gcc.gnu.org/onlinedocs/gcc/x86-Options.html
  # For ARM here: https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html
  # If you set "march" to "native", specify "mtune" as well; otherwise, it will be set to "generic". (credit to: https://lemire.me/blog/2018/07/25/it-is-more-complicated-than-i-thought-mtune-march-in-gcc/)
  # For example, if you have an AMD Ryzen CPU, you will set "march" to "x86-64" and "mtune" to "znver2"
  march ? "",
  mtune ? "",
}:

let
  makeBool = option: bool: (if bool then "${option}=1" else "");

  effectiveStdenv = if cublasSupport then cudaPackages.backendStdenv else stdenv;
in
effectiveStdenv.mkDerivation (finalAttrs: {
  pname = "koboldcpp";
  version = "1.68";

  src = fetchFromGitHub {
    owner = "LostRuins";
    repo = "koboldcpp";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-zqRlQ8HgT4fmGHD6uxxa2duZrx9Vhxd+gm1XQ7w9ay0=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    makeWrapper
    python311Packages.wrapPython
  ];

  pythonInputs = builtins.attrValues { inherit (python311Packages) tkinter customtkinter packaging; };

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

  env.NIX_CFLAGS_COMPILE =
    lib.optionalString (march != "") "-march=${march}" + lib.optionalString (mtune != "") "-mtune=${mtune}";

  makeFlags = [
    (makeBool "LLAMA_OPENBLAS" openblasSupport)
    (makeBool "LLAMA_CUBLAS" cublasSupport)
    (makeBool "LLAMA_CLBLAST" clblastSupport)
    (makeBool "LLAMA_VULKAN" vulkanSupport)
    (makeBool "LLAMA_METAL" metalSupport)
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

  postFixup = ''
    wrapPythonProgramsIn "$out/bin" "$pythonPath"
    makeWrapper "$out/bin/koboldcpp.unwrapped" "$out/bin/koboldcpp" \
    --prefix PATH ${lib.makeBinPath [ tk ]}
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "A way to run various GGML and GGUF models";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      maxstrid
      donteatoreo
    ];
    mainProgram = "koboldcpp";
    platforms = lib.platforms.unix;
  };
})
