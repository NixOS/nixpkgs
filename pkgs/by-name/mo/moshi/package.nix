{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  pkg-config,
  python3,
  autoPatchelfHook,
  autoAddDriverRunpath,

  # buildInputs
  libopus,
  openssl,
  sentencepiece,
  alsa-lib,

  # passthru
  moshi,
  nix-update-script,

  config,
  cudaPackages,
  cudaCapability ? null,
}:

let
  minRequiredCudaCapability = "6.1"; # build fails with 6.0
  inherit (cudaPackages.flags) cudaCapabilities;
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
  cudaCapability' = lib.toInt (cudaPackages.flags.dropDots cudaCapabilityString);
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "moshi";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "kyutai-labs";
    repo = "moshi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MkZsLRQE5Swdyp9l/cvPvznWxRfKuYecj+TTgb3ufKU=";
  };

  sourceRoot = "${finalAttrs.src.name}/rust";

  cargoHash = "sha256-BxV8oZlN+6cVb3GwhY7TKWxHEpY3WVEhN6A6+5NMOyU=";

  nativeBuildInputs = [
    pkg-config
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Unable to find libclang: "couldn't find any valid shared libraries matching: ['libclang.dylib']
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals config.cudaSupport [
    # WARNING: autoAddDriverRunpath must run AFTER autoPatchelfHook
    # Otherwise, autoPatchelfHook removes driverLink from RUNPATH
    autoPatchelfHook
    autoAddDriverRunpath

    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    libopus
    openssl
    sentencepiece
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ]
  ++ lib.optionals config.cudaSupport [
    cudaPackages.cuda_cccl
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvrtc
    cudaPackages.libcublas
    cudaPackages.libcurand
  ];

  buildFeatures =
    lib.optionals stdenv.hostPlatform.isDarwin [ "metal" ]
    ++ lib.optionals config.cudaSupport [ "cuda" ];

  env = lib.optionalAttrs config.cudaSupport {
    CUDA_COMPUTE_CAP = cudaCapability';

    # We already list CUDA dependencies in buildInputs
    # We only set CUDA_TOOLKIT_ROOT_DIR to satisfy some redundant checks from upstream
    CUDA_TOOLKIT_ROOT_DIR = lib.getDev cudaPackages.cuda_cudart;
  };

  appendRunpaths = lib.optionals config.cudaSupport [
    (lib.makeLibraryPath [
      cudaPackages.libcublas
      cudaPackages.libcurand
    ])
  ];

  passthru = {
    tests = {
      withCuda = lib.optionalAttrs stdenv.hostPlatform.isLinux (
        moshi.override { config.cudaSupport = true; }
      );
    };
    updateScript = nix-update-script {
      extraArgs = [ "--generate-lockfile" ];
    };
  };

  meta = {
    description = "Rust implementation of moshi, a real-time voice AI";
    homepage = "https://github.com/kyutai-labs/moshi";
    # The rust implementation is licensed under Apache
    # https://github.com/kyutai-labs/moshi/tree/main/rust#license
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.all;
    mainProgram = "moshi-cli";
  };
})
