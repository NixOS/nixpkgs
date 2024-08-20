{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
  buildEnv,
  linkFarm,
  overrideCC,
  makeWrapper,
  stdenv,
  addDriverRunpath,

  cmake,
  gcc12,
  clblast,
  libdrm,
  rocmPackages,
  cudaPackages,
  darwin,
  autoAddDriverRunpath,

  nixosTests,
  testers,
  ollama,
  ollama-rocm,
  ollama-cuda,

  config,
  # one of `[ null false "rocm" "cuda" ]`
  acceleration ? null,
}:

assert builtins.elem acceleration [
  null
  false
  "rocm"
  "cuda"
];

let
  pname = "ollama";
  # don't forget to invalidate all hashes each update
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-2lPOkpZ9AmgDFoIHKi+Im1AwXnTxSY3LLtyui1ep3Dw=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-hSxcREAujhvzHVNwnRTfhi0MKI3s8HNavER2VLz6SYk=";

  # ollama's patches of llama.cpp's example server
  # `ollama/llm/generate/gen_common.sh` -> "apply temporary patches until fix is upstream"
  # each update, these patches should be synchronized with the contents of `ollama/llm/patches/`
  llamacppPatches = [
    (preparePatch "01-load-progress.diff" "sha256-UTmnBS5hQjIL3eXDZc8RBDNJunLlkqJWH20LpXNiGRQ=")
    (preparePatch "02-clip-log.diff" "sha256-rMWbl3QgrPlhisTeHwD7EnGRJyOhLB4UeS7rqa0tdXM=")
    (preparePatch "03-load_exception.diff" "sha256-NJkT/k8Mf8HcEMb0XkaLmyUNKV3T+384JRPnmwDI/sk=")
    (preparePatch "04-metal.diff" "sha256-bPBCfoT3EjZPjWKfCzh0pnCUbM/fGTj37yOaQr+QxQ4=")
    (preparePatch "05-default-pretokenizer.diff" "sha256-PQ0DgfzycUQ8t6S6/yjsMHHx/nFJ0w8AH6afv5Po89w=")
    (preparePatch "06-embeddings.diff" "sha256-lqg2SI0OapD9LCoAG6MJW6HIHXEmCTv7P75rE9yq/Mo=")
    (preparePatch "07-clip-unicode.diff" "sha256-1qMJoXhDewxsqPbmi+/7xILQfGaybZDyXc5eH0winL8=")
    (preparePatch "08-pooling.diff" "sha256-7meKWbr06lbVrtxau0AU9BwJ88Z9svwtDXhmHI+hYBk=")
    (preparePatch "09-lora.diff" "sha256-tNtI3WHHjBq+PJZGJCBsXHa15dlNJeJm+IiaUbFC0LE=")
    (preparePatch "11-phi3-sliding-window.diff" "sha256-VbcR4SLa9UXoh8Jq/bPVBerxfg68JZyWALRs7fz7hEs=")
  ];

  preparePatch =
    patch: hash:
    fetchpatch {
      url = "file://${src}/llm/patches/${patch}";
      inherit hash;
      stripLen = 1;
      extraPrefix = "llm/llama.cpp/";
    };

  validateFallback = lib.warnIf (config.rocmSupport && config.cudaSupport) (lib.concatStrings [
    "both `nixpkgs.config.rocmSupport` and `nixpkgs.config.cudaSupport` are enabled, "
    "but they are mutually exclusive; falling back to cpu"
  ]) (!(config.rocmSupport && config.cudaSupport));
  shouldEnable =
    mode: fallback: (acceleration == mode) || (fallback && acceleration == null && validateFallback);

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
  rocmClang = linkFarm "rocm-clang" { llvm = rocmPackages.llvm.clang; };
  rocmPath = buildEnv {
    name = "rocm-path";
    paths = rocmLibs ++ [ rocmClang ];
  };

  cudaToolkit = buildEnv {
    name = "cuda-merged";
    paths = [
      (lib.getBin (cudaPackages.cuda_nvcc.__spliced.buildHost or cudaPackages.cuda_nvcc))
      (lib.getLib cudaPackages.cuda_cudart)
      (lib.getOutput "static" cudaPackages.cuda_cudart)
      (lib.getLib cudaPackages.libcublas)
    ];
  };

  metalFrameworks = with darwin.apple_sdk_11_0.frameworks; [
    Accelerate
    Metal
    MetalKit
    MetalPerformanceShaders
  ];

  wrapperOptions =
    [
      # ollama embeds llama-cpp binaries which actually run the ai models
      # these llama-cpp binaries are unaffected by the ollama binary's DT_RUNPATH
      # LD_LIBRARY_PATH is temporarily required to use the gpu
      # until these llama-cpp binaries can have their runpath patched
      "--suffix LD_LIBRARY_PATH : '${addDriverRunpath.driverLink}/lib'"
    ]
    ++ lib.optionals enableRocm [
      "--suffix LD_LIBRARY_PATH : '${rocmPath}/lib'"
      "--set-default HIP_PATH '${rocmPath}'"
    ];
  wrapperArgs = builtins.concatStringsSep " " wrapperOptions;

  goBuild =
    if enableCuda then buildGoModule.override { stdenv = overrideCC stdenv gcc12; } else buildGoModule;
  inherit (lib) licenses platforms maintainers;
in
goBuild (
  (lib.optionalAttrs enableRocm {
    ROCM_PATH = rocmPath;
    CLBlast_DIR = "${clblast}/lib/cmake/CLBlast";
  })
  // (lib.optionalAttrs enableCuda { CUDA_LIB_DIR = "${cudaToolkit}/lib"; })
  // {
    inherit
      pname
      version
      src
      vendorHash
      ;

    nativeBuildInputs =
      [ cmake ]
      ++ lib.optionals enableRocm [ rocmPackages.llvm.bintools ]
      ++ lib.optionals enableCuda [ cudaPackages.cuda_nvcc ]
      ++ lib.optionals (enableRocm || enableCuda) [
        makeWrapper
        autoAddDriverRunpath
      ]
      ++ lib.optionals stdenv.isDarwin metalFrameworks;

    buildInputs =
      lib.optionals enableRocm (rocmLibs ++ [ libdrm ])
      ++ lib.optionals enableCuda [
        cudaPackages.cuda_cudart
        cudaPackages.cuda_cccl
        cudaPackages.libcublas
      ]
      ++ lib.optionals stdenv.isDarwin metalFrameworks;

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
    postFixup =
      ''
        # the app doesn't appear functional at the moment, so hide it
        mv "$out/bin/app" "$out/bin/.ollama-app"
      ''
      + lib.optionalString (enableRocm || enableCuda) ''
        # expose runtime libraries necessary to use the gpu
        wrapProgram "$out/bin/ollama" ${wrapperArgs}
      '';

    ldflags = [
      "-s"
      "-w"
      "-X=github.com/ollama/ollama/version.Version=${version}"
      "-X=github.com/ollama/ollama/server.mode=release"
    ];

    passthru.tests =
      {
        inherit ollama;
        version = testers.testVersion {
          inherit version;
          package = ollama;
        };
      }
      // lib.optionalAttrs stdenv.isLinux {
        inherit ollama-rocm ollama-cuda;
        service = nixosTests.ollama;
        service-cuda = nixosTests.ollama-cuda;
        service-rocm = nixosTests.ollama-rocm;
      };

    meta = {
      description =
        "Get up and running with large language models locally"
        + lib.optionalString rocmRequested ", using ROCm for AMD GPU acceleration"
        + lib.optionalString cudaRequested ", using CUDA for NVIDIA GPU acceleration";
      homepage = "https://github.com/ollama/ollama";
      changelog = "https://github.com/ollama/ollama/releases/tag/v${version}";
      license = licenses.mit;
      platforms = if (rocmRequested || cudaRequested) then platforms.linux else platforms.unix;
      mainProgram = "ollama";
      maintainers = with maintainers; [
        abysssol
        dit7ya
        elohmeier
        roydubnium
      ];
    };
  }
)
