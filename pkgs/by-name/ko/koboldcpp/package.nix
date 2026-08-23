{
  lib,
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

  vulkanSupport ? false,
  vulkan-loader,
  shaderc,
  metalSupport ? false,
  nix-update-script,
}:

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

  libraryPathWrapperArgs = lib.optionals (cublasSupport && stdenv.hostPlatform.isLinux) [
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [ addDriverRunpath.driverLink ])
  ];

  runtimePath = [ tk ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath runtimePath)
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
  ++ lib.optionals vulkanSupport [ "koboldcpp_vulkan" ]
  ++ lib.optionals (vulkanSupport && stdenv.hostPlatform.isx86) [
    "koboldcpp_vulkan_failsafe"
    "koboldcpp_vulkan_noavx2"
  ];

  effectiveStdenv = if cublasSupport then cudaPackages.backendStdenv else stdenv;

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
    cudaPackages.cccl
  ]
  ++ lib.optionals vulkanSupport [
    vulkan-loader
  ];

  pythonPath = finalAttrs.pythonInputs;

  env = lib.optionalAttrs vulkanSupport {
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
  ++ lib.optionals vulkanSupport [
    "LLAMA_VULKAN=1"
    "LLAMA_USE_BUNDLED_GLSLC="
  ]
  ++ lib.optionals metalSupport [ "LLAMA_METAL=1" ];

  buildFlags = builtLibraries;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"

    install -Dm755 koboldcpp.py "$out/bin/koboldcpp.unwrapped"
    install -Dm755 ${lib.escapeShellArgs (map (library: "${library}.so") builtLibraries)} "$out/bin"
    cp -r embd_res "$out/bin"

    ${lib.optionalString metalSupport ''
      install -Dm755 ${metalFailsafe}/lib/koboldcpp_failsafe.so "$out/bin"
      install -Dm644 *.metal "$out/bin"
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
      ${lib.escapeShellArgs makeWrapperArgs}
  '';

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
    platforms = if metalSupport then lib.platforms.darwin else lib.platforms.unix;
    badPlatforms = lib.optionals cublasSupport lib.platforms.darwin;
    broken = metalSupport && !effectiveStdenv.hostPlatform.isDarwin;
  };
})
