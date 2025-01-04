{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  pkg-config,
  python3,

  # buildInputs
  libopus,
  openssl,
  sentencepiece,
  alsa-lib,
  darwin,

  config,
  cudaPackages,
  cudaCapability ? null,

  testers,
  moshi,
  nix-update-script,
}:

let
  hash = "sha256-zcs+Yg89MZaXQm4Yz+hcU9R0y7p/QxhNyc6GC/imwpc=";

  minRequiredCudaCapability = "6.1"; # build fails with 6.0
  inherit (cudaPackages.cudaFlags) cudaCapabilities;
  cudaCapabilityString =
    if cudaCapability == null then
      (builtins.head (
        (builtins.filter (cap: lib.versionAtLeast cap minRequiredCudaCapability) cudaCapabilities)
        ++ [
          (lib.warn "moshi doesn't support ${lib.concatStringsSep " " cudaCapabilities}" minRequiredCudaCapability)
        ]
      ))
    else
      cudaCapability;
  cudaCapability' = lib.toInt (cudaPackages.cudaFlags.dropDot cudaCapabilityString);
in
rustPlatform.buildRustPackage rec {
  pname = "moshi";
  version = "0-unstable-2024-09-19";

  src = fetchFromGitHub {
    owner = "kyutai-labs";
    repo = "moshi";
    rev = "f47ece4043314a42c5dbb9c39a158cecdb65dc03";
    inherit hash;
  };

  sourceRoot = "${src.name}/rust";

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    rustPlatform.bindgenHook
  ] ++ lib.optionals config.cudaSupport [ cudaPackages.cuda_nvcc ];

  dontUseCmakeConfigure = true;

  buildInputs =
    [
      libopus
      openssl
      sentencepiece
    ]
    ++ lib.optionals stdenv.isLinux [ alsa-lib ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.AudioUnit
      darwin.apple_sdk.frameworks.CoreAudio
      darwin.apple_sdk.frameworks.MetalKit
      darwin.apple_sdk.frameworks.MetalPerformanceShaders
    ]
    ++ lib.optionals config.cudaSupport [
      cudaPackages.cuda_cudart
      cudaPackages.cuda_nvrtc
      cudaPackages.libcublas
      cudaPackages.libcurand
    ];

  buildFeatures =
    lib.optionals stdenv.isDarwin [ "metal" ]
    ++ lib.optionals config.cudaSupport [ "cuda" ];

  env =
    {
      VERGEN_GIT_SHA = hash;
      VERGEN_GIT_COMMIT_TIMESTAMP = "0";
      VERGEN_GIT_BRANCH = "master";
    }
    // lib.optionalAttrs config.cudaSupport {
      CUDA_COMPUTE_CAP = cudaCapability';
      CUDA_TOOLKIT_ROOT_DIR = lib.getDev cudaPackages.cuda_cudart;
    };

  NVCC_PREPEND_FLAGS = lib.optionals config.cudaSupport [
    "-I${lib.getDev cudaPackages.cuda_cudart}/include"
    "-I${lib.getDev cudaPackages.cuda_cccl}/include"
  ];

  passthru = {
    tests = {
      # No semantic versions yet
      # version = testers.testVersion { package = moshi; };

      withCuda = lib.optionalAttrs stdenv.isLinux (moshi.override { config.cudaSupport = true; });
    };
    # No semantic versions yet
    # updateScript = nix-update-script { };
  };

  meta = {
    description = "Rust implementation of moshi, a real-time voice AI";
    homepage = "https://github.com/kyutai-labs/moshi";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.all;
  };
}
