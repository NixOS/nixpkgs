{
  lib,
  rustPlatform,
  fetchFromGitHub,

  # nativeBuildInputs
  pkg-config,
  python3,

  # buildInputs
  oniguruma,
  openssl,
  mkl,
  stdenv,
  darwin,

  # env
  fetchurl,

  testers,
  mistral-rs,

  cudaPackages,
  cudaCapability ? null,

  config,
  # one of `[ null false "cuda" "mkl" "metal" ]`
  acceleration ? null,

}:

let
  accelIsValid = builtins.elem acceleration [
    null
    false
    "cuda"
    "mkl"
    "metal"
  ];

  cudaSupport =
    assert accelIsValid;
    (acceleration == "cuda") || (config.cudaSupport && acceleration == null);

  minRequiredCudaCapability = "6.1"; # build fails with 6.0
  inherit (cudaPackages.cudaFlags) cudaCapabilities;
  cudaCapabilityString =
    if cudaCapability == null then
      (builtins.head (
        (builtins.filter (cap: lib.versionAtLeast cap minRequiredCudaCapability) cudaCapabilities)
        ++ [
          (lib.warn "mistral-rs doesn't support ${lib.concatStringsSep " " cudaCapabilities}" minRequiredCudaCapability)
        ]
      ))
    else
      cudaCapability;
  cudaCapability' = lib.toInt (cudaPackages.cudaFlags.dropDot cudaCapabilityString);

  # TODO Should we assert mklAccel -> stdenv.isLinux && stdenv.isx86_64 ?
  mklSupport =
    assert accelIsValid;
    (acceleration == "mkl");

  metalSupport =
    assert accelIsValid;
    (acceleration == "metal") || (stdenv.isDarwin && stdenv.isAarch64 && (acceleration == null));

  darwinBuildInputs =
    with darwin.apple_sdk.frameworks;
    [
      Accelerate
      CoreVideo
      CoreGraphics
    ]
    ++ lib.optionals metalSupport [
      MetalKit
      MetalPerformanceShaders
    ];
in

rustPlatform.buildRustPackage rec {
  pname = "mistral-rs";
  version = "0.1.18";

  src = fetchFromGitHub {
    owner = "EricLBuehler";
    repo = "mistral.rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-lMDFWNv9b0UfckqLmyWRVwnqmGe6nxYsUHzoi2+oG84=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "candle-core-0.6.0" = "sha256-DxGBWf2H7MamrbboTJ4zHy1HeE8ZVT7QvE3sTYrRxBc=";
      "range-checked-0.1.0" = "sha256-S+zcF13TjwQPFWZLIbUDkvEeaYdaxCOtDLtI+JRvum8=";
    };
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
    python3
  ] ++ lib.optionals cudaSupport [ cudaPackages.cuda_nvcc ];

  buildInputs =
    [
      oniguruma
      openssl
    ]
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_nvrtc
      cudaPackages.libcublas
      cudaPackages.libcurand
    ]
    ++ lib.optionals mklSupport [ mkl ]
    ++ lib.optionals stdenv.isDarwin darwinBuildInputs;

  cargoBuildFlags =
    lib.optionals cudaSupport [ "--features=cuda" ]
    ++ lib.optionals mklSupport [ "--features=mkl" ]
    ++ lib.optionals (stdenv.isDarwin && metalSupport) [ "--features=metal" ];

  env =
    {
      SWAGGER_UI_DOWNLOAD_URL =
        let
          # When updating:
          # - Look for the version of `utopia-swagger-ui` at:
          #   https://github.com/EricLBuehler/mistral.rs/blob/v<MISTRAL-RS-VERSION>/mistralrs-server/Cargo.toml
          # - Look at the corresponding version of `swagger-ui` at:
          #   https://github.com/juhaku/utoipa/blob/utoipa-swagger-ui-<UTOPIA-SWAGGER-UI-VERSION>/utoipa-swagger-ui/build.rs#L21-L22
          swaggerUiVersion = "5.17.12";

          swaggerUi = fetchurl {
            url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v${swaggerUiVersion}.zip";
            hash = "sha256-HK4z/JI+1yq8BTBJveYXv9bpN/sXru7bn/8g5mf2B/I=";
          };
        in
        "file://${swaggerUi}";

      RUSTONIG_SYSTEM_LIBONIG = true;
    }
    // (lib.optionalAttrs cudaSupport {
      CUDA_COMPUTE_CAP = cudaCapability';

      # Apparently, cudart is enough: No need to provide the entire cudaPackages.cudatoolkit derivation.
      CUDA_TOOLKIT_ROOT_DIR = lib.getDev cudaPackages.cuda_cudart;
    });

  NVCC_PREPEND_FLAGS = lib.optionals cudaSupport [
    "-I${lib.getDev cudaPackages.cuda_cudart}/include"
    "-I${lib.getDev cudaPackages.cuda_cccl}/include"
  ];

  # swagger-ui will once more be copied in the target directory during the check phase
  # Not deleting the existing unpacked archive leads to a `PermissionDenied` error
  preCheck = ''
    rm -rf target/${stdenv.hostPlatform.config}/release/build/
  '';

  # Try to access internet
  checkFlags = [
    "--skip=gguf::gguf_tokenizer::tests::test_decode_gpt2"
    "--skip=gguf::gguf_tokenizer::tests::test_decode_llama"
    "--skip=gguf::gguf_tokenizer::tests::test_encode_gpt2"
    "--skip=gguf::gguf_tokenizer::tests::test_encode_llama"
    "--skip=sampler::tests::test_argmax"
    "--skip=sampler::tests::test_gumbel_speculative"
  ];

  passthru = {
    tests = {
      version = testers.testVersion { package = mistral-rs; };

      withMkl = mistral-rs.override { acceleration = "mkl"; };
      withCuda = mistral-rs.override { acceleration = "cuda"; };
      withMetal = mistral-rs.override { acceleration = "metal"; };
    };
  };

  meta = {
    description = "Blazingly fast LLM inference";
    homepage = "https://github.com/EricLBuehler/mistral.rs";
    changelog = "https://github.com/EricLBuehler/mistral.rs/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "mistralrs-server";
    platforms =
      if cudaSupport then
        lib.platforms.linux
      else if metalSupport then
        [ "aarch64-darwin" ]
      else
        lib.platforms.unix;
    broken = mklSupport;
  };
}
