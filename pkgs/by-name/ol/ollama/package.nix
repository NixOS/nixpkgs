{ lib
, buildGo122Module
, fetchFromGitHub
, fetchpatch
, buildEnv
, linkFarm
, overrideCC
, makeWrapper
, stdenv

, cmake
, gcc12
, clblast
, libdrm
, rocmPackages
, cudaPackages
, linuxPackages
, darwin

, nixosTests
, testers
, ollama
, ollama-rocm
, ollama-cuda

, config
  # one of `[ null false "rocm" "cuda" ]`
, acceleration ? null
}:

let
  pname = "ollama";
  # don't forget to invalidate all hashes each update
  version = "0.1.44";

  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-HM7xtVdhRwhsLEBLvCgjU1iwdaqowRdrxh/Z0BzTPn8=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-LNH3mpxIrPMe5emfum1W10jvXIjKC6GkGcjq1HhpJQo=";

  # ollama's patches of llama.cpp's example server
  # `ollama/llm/generate/gen_common.sh` -> "apply temporary patches until fix is upstream"
  # each update, these patches should be synchronized with the contents of `ollama/llm/patches/`
  llamacppPatches = [
    (preparePatch "01-load-progress.diff" "sha256-3QxyKX1n5NeMLU8d7wI/96wCM1Cvb5X5sQL5CFhMFo4=")
    (preparePatch "02-clip-log.diff" "sha256-rMWbl3QgrPlhisTeHwD7EnGRJyOhLB4UeS7rqa0tdXM=")
    (preparePatch "03-load_exception.diff" "sha256-0XfMtMyg17oihqSFDBakBtAF0JwhsR188D+cOodgvDk=")
    (preparePatch "04-metal.diff" "sha256-Ne8J9R8NndUosSK0qoMvFfKNwqV5xhhce1nSoYrZo7Y=")
    (preparePatch "05-default-pretokenizer.diff" "sha256-NrQ0Fv5DAZYtRM0NBEeM2JLVTLFmb4Fs9RhwXhdMCC4=")
    (preparePatch "06-qwen2.diff" "sha256-nMtoAQUsjYuJv45uTlz8r/K1oF5NUsc75SnhgfSkE30=")
  ];

  preparePatch = patch: hash: fetchpatch {
    url = "file://${src}/llm/patches/${patch}";
    inherit hash;
    stripLen = 1;
    extraPrefix = "llm/llama.cpp/";
  };


  accelIsValid = builtins.elem acceleration [ null false "rocm" "cuda" ];
  validateFallback = lib.warnIf (config.rocmSupport && config.cudaSupport)
    (lib.concatStrings [
      "both `nixpkgs.config.rocmSupport` and `nixpkgs.config.cudaSupport` are enabled, "
      "but they are mutually exclusive; falling back to cpu"
    ])
    (!(config.rocmSupport && config.cudaSupport));
  shouldEnable = assert accelIsValid;
    mode: fallback:
      (acceleration == mode)
      || (fallback && acceleration == null && validateFallback);

  rocmRequested = shouldEnable "rocm" config.rocmSupport;
  cudaRequested = shouldEnable "cuda" config.cudaSupport;

  enableRocm = rocmRequested && stdenv.isLinux;
  enableCuda = cudaRequested && stdenv.isLinux;


  rocmLibs = [
    rocmPackages.clr
    rocmPackages.hipblas
    rocmPackages.rocblas
    rocmPackages.rocsolver
    rocmPackages.rocsparse
    rocmPackages.rocm-device-libs
    rocmPackages.rocm-smi
  ];
  rocmClang = linkFarm "rocm-clang" {
    llvm = rocmPackages.llvm.clang;
  };
  rocmPath = buildEnv {
    name = "rocm-path";
    paths = rocmLibs ++ [ rocmClang ];
  };

  cudaToolkit = buildEnv {
    name = "cuda-toolkit";
    ignoreCollisions = true; # FIXME: find a cleaner way to do this without ignoring collisions
    paths = [
      cudaPackages.cudatoolkit
      cudaPackages.cuda_cudart
      cudaPackages.cuda_cudart.static
    ];
  };

  runtimeLibs = lib.optionals enableRocm [
    rocmPath
  ] ++ lib.optionals enableCuda [
    linuxPackages.nvidia_x11
  ];

  appleFrameworks = darwin.apple_sdk_11_0.frameworks;
  metalFrameworks = [
    appleFrameworks.Accelerate
    appleFrameworks.Metal
    appleFrameworks.MetalKit
    appleFrameworks.MetalPerformanceShaders
  ];


  goBuild =
    if enableCuda then
      buildGo122Module.override { stdenv = overrideCC stdenv gcc12; }
    else
      buildGo122Module;
  inherit (lib) licenses platforms maintainers;
in
goBuild ((lib.optionalAttrs enableRocm {
  ROCM_PATH = rocmPath;
  CLBlast_DIR = "${clblast}/lib/cmake/CLBlast";
}) // (lib.optionalAttrs enableCuda {
  CUDA_LIB_DIR = "${cudaToolkit}/lib";
  CUDACXX = "${cudaToolkit}/bin/nvcc";
  CUDAToolkit_ROOT = cudaToolkit;
}) // {
  inherit pname version src vendorHash;

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals enableRocm [
    rocmPackages.llvm.bintools
  ] ++ lib.optionals (enableRocm || enableCuda) [
    makeWrapper
  ] ++ lib.optionals stdenv.isDarwin
    metalFrameworks;

  buildInputs = lib.optionals enableRocm
    (rocmLibs ++ [ libdrm ])
  ++ lib.optionals enableCuda [
    cudaPackages.cuda_cudart
  ] ++ lib.optionals stdenv.isDarwin
    metalFrameworks;

  patches = [
    # disable uses of `git` in the `go generate` script
    # ollama's build script assumes the source is a git repo, but nix removes the git directory
    # this also disables necessary patches contained in `ollama/llm/patches/`
    # those patches are added to `llamacppPatches`, and reapplied here in the patch phase
    ./disable-git.patch
    # disable a check that unnecessarily exits compilation during rocm builds
    # since `rocmPath` is in `LD_LIBRARY_PATH`, ollama uses rocm correctly
    ./disable-lib-check.patch
  ] ++ llamacppPatches;
  postPatch = ''
    # replace inaccurate version number with actual release version
    substituteInPlace version/version.go --replace-fail 0.0.0 '${version}'
  '';
  preBuild = ''
    # disable uses of `git`, since nix removes the git directory
    export OLLAMA_SKIP_PATCHING=true
    # build llama.cpp libraries for ollama
    go generate ./...
  '';
  postFixup = ''
    # the app doesn't appear functional at the moment, so hide it
    mv "$out/bin/app" "$out/bin/.ollama-app"
  '' + lib.optionalString (enableRocm || enableCuda) ''
    # expose runtime libraries necessary to use the gpu
    mv "$out/bin/ollama" "$out/bin/.ollama-unwrapped"
    makeWrapper "$out/bin/.ollama-unwrapped" "$out/bin/ollama" ${
      lib.optionalString enableRocm
        ''--set-default HIP_PATH '${rocmPath}' ''} \
      --suffix LD_LIBRARY_PATH : '/run/opengl-driver/lib:${lib.makeLibraryPath runtimeLibs}'
  '';

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/jmorganca/ollama/version.Version=${version}"
    "-X=github.com/jmorganca/ollama/server.mode=release"
  ];

  passthru.tests = {
    inherit ollama;
    service = nixosTests.ollama;
    version = testers.testVersion {
      inherit version;
      package = ollama;
    };
  } // lib.optionalAttrs stdenv.isLinux {
    inherit ollama-rocm ollama-cuda;
  };

  meta = {
    description = "Get up and running with large language models locally"
      + lib.optionalString rocmRequested ", using ROCm for AMD GPU acceleration"
      + lib.optionalString cudaRequested ", using CUDA for NVIDIA GPU acceleration";
    homepage = "https://github.com/ollama/ollama";
    changelog = "https://github.com/ollama/ollama/releases/tag/v${version}";
    license = licenses.mit;
    platforms =
      if (rocmRequested || cudaRequested) then platforms.linux
      else platforms.unix;
    mainProgram = "ollama";
    maintainers = with maintainers; [ abysssol dit7ya elohmeier roydubnium ];
  };
})
