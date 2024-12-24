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

  versionCheckHook,

  testers,
  mistral-rs,
  nix-update-script,

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

  mklSupport =
    assert accelIsValid;
    (acceleration == "mkl");

  metalSupport =
    assert accelIsValid;
    (acceleration == "metal")
    || (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 && (acceleration == null));

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
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "EricLBuehler";
    repo = "mistral.rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-aflzpJZ48AFBqNTssZl2KxkspQb662nGkEU6COIluxk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-USp8siEXVjtkPoCHfQjDYPtgLfNHcy02LSUNdwDbxgs=";

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
      cudaPackages.cuda_cudart
      cudaPackages.cuda_nvrtc
      cudaPackages.libcublas
      cudaPackages.libcurand
    ]
    ++ lib.optionals mklSupport [ mkl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin darwinBuildInputs;

  cargoBuildFlags =
    [
      # This disables the plotly crate which fails to build because of the kaleido feature requiring
      # network access at build-time.
      # See https://github.com/NixOS/nixpkgs/pull/323788#issuecomment-2206085825
      "--no-default-features"
    ]
    ++ lib.optionals cudaSupport [ "--features=cuda" ]
    ++ lib.optionals mklSupport [ "--features=mkl" ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && metalSupport) [ "--features=metal" ];

  env =
    {
      SWAGGER_UI_DOWNLOAD_URL =
        let
          # When updating:
          # - Look for the version of `utoipa-swagger-ui` at:
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
    "--skip=gguf::gguf_tokenizer::tests::test_encode_decode_gpt2"
    "--skip=gguf::gguf_tokenizer::tests::test_encode_decode_llama"
    "--skip=gguf::gguf_tokenizer::tests::test_encode_gpt2"
    "--skip=gguf::gguf_tokenizer::tests::test_encode_llama"
    "--skip=sampler::tests::test_argmax"
    "--skip=sampler::tests::test_gumbel_speculative"
    "--skip=util::tests::test_parse_image_url"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/mistralrs-server";
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    tests = {
      version = testers.testVersion { package = mistral-rs; };

      # TODO: uncomment when mkl support will be fixed
      withMkl = lib.optionalAttrs (stdenv.hostPlatform == "x86_64-linux") (
        mistral-rs.override { acceleration = "mkl"; }
      );
      withCuda = lib.optionalAttrs stdenv.hostPlatform.isLinux (
        mistral-rs.override { acceleration = "cuda"; }
      );
      withMetal = lib.optionalAttrs (stdenv.hostPlatform == "aarch64-darwin") (
        mistral-rs.override { acceleration = "metal"; }
      );
    };
    updateScript = nix-update-script { };
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
      else if mklSupport then
        [ "x86_64-linux" ]
      else
        lib.platforms.unix;
    broken = mklSupport;
  };
}
