{
  lib,
  buildGoModule,
  fetchFromGitHub,
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
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama";
    rev = "v${version}";
    hash = "sha256-iNjqnhiM0L873BiBPAgI2Y0KEQyCInn2nEihzwLasFU=";
    fetchSubmodules = true;
  };

  vendorHash = "sha256-hSxcREAujhvzHVNwnRTfhi0MKI3s8HNavER2VLz6SYk=";

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
        cudaToolkit
        cudaPackages.cuda_cudart
        cudaPackages.cuda_cccl
        cudaPackages.libcublas
      ]
      ++ lib.optionals stdenv.isDarwin metalFrameworks;

    patches = [
      # disable uses of `git` in the `go generate` script
      # ollama's build script assumes the source is a git repo, but nix removes the git directory
      # this also disables necessary patches contained in `ollama/llm/patches/`
      # those patches are applied in `postPatch`
      ./disable-git.patch
    ];

    postPatch = ''
      # replace inaccurate version number with actual release version
      substituteInPlace version/version.go --replace-fail 0.0.0 '${version}'

      # apply llama.cpp patches
      for cur in llm/patches/*; do patch -p1 -d llm/llama.cpp < $cur; done
    '';

    overrideModAttrs = (
      finalAttrs: prevAttrs: {
        # don't run llama.cpp build in the module fetch phase
        preBuild = "";
      }
    );

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
