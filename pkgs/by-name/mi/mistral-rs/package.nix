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
  oniguruma,
  openssl,
  mkl,

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
  inherit (stdenv) hostPlatform;

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
  inherit (cudaPackages.flags) cudaCapabilities;
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
  cudaCapability' = lib.toInt (cudaPackages.flags.dropDots cudaCapabilityString);

  mklSupport =
    assert accelIsValid;
    (acceleration == "mkl");

  metalSupport =
    assert accelIsValid;
    (acceleration == "metal")
    || (hostPlatform.isDarwin && hostPlatform.isAarch64 && (acceleration == null));

in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mistral-rs";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "EricLBuehler";
    repo = "mistral.rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mkxgssJUBtM1DYOhFfj8YKlW61/gd0cgPtMze7YZ9L8=";
  };

  patches = [
    ./no-native-cpu.patch
  ];

  cargoHash = "sha256-YGGtS8gJJQKIgXxMWjO05ikSVdfVNs+cORbJ+Wf88y4=";

  nativeBuildInputs = [
    pkg-config
    python3
  ]
  ++ lib.optionals cudaSupport [
    # WARNING: autoAddDriverRunpath must run AFTER autoPatchelfHook
    # Otherwise, autoPatchelfHook removes driverLink from RUNPATH
    autoPatchelfHook
    autoAddDriverRunpath

    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    oniguruma
    openssl
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cccl
    cudaPackages.cuda_cudart
    cudaPackages.cuda_nvrtc
    cudaPackages.libcublas
    cudaPackages.libcurand
  ]
  ++ lib.optionals mklSupport [ mkl ];

  buildFeatures =
    lib.optionals cudaSupport [ "cuda" ]
    ++ lib.optionals mklSupport [ "mkl" ]
    ++ lib.optionals (hostPlatform.isDarwin && metalSupport) [ "metal" ];

  env = {
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

    # We already list CUDA dependencies in buildInputs
    # We only set CUDA_TOOLKIT_ROOT_DIR to satisfy some redundant checks from upstream
    CUDA_TOOLKIT_ROOT_DIR = lib.getDev cudaPackages.cuda_cudart;
  });

  appendRunpaths = lib.optionals cudaSupport [
    (lib.makeLibraryPath [
      cudaPackages.libcublas
      cudaPackages.libcurand
    ])
  ];

  # swagger-ui will once more be copied in the target directory during the check phase
  # See https://github.com/juhaku/utoipa/blob/utoipa-swagger-ui-7.1.0/utoipa-swagger-ui/build.rs#L168
  # Not deleting the existing unpacked archive leads to a `PermissionDenied` error
  preCheck = ''
    rm -rf target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/build/
  '';

  # Prevent checkFeatures from inheriting buildFeatures because
  # - `cargo check ... --features=cuda` requires access to a real GPU
  # - `cargo check ... --features=metal` (on darwin) requires the sandbox to be completely disabled
  checkFeatures = [ ];

  # Try to access internet
  checkFlags = [
    "--skip=gguf::gguf_tokenizer::tests::test_encode_decode_gpt2"
    "--skip=gguf::gguf_tokenizer::tests::test_encode_decode_llama"
    "--skip=util::tests::test_parse_image_url"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/mistralrs-server";
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    tests = {
      version = testers.testVersion { package = mistral-rs; };

      withMkl = lib.optionalAttrs (hostPlatform.isLinux && hostPlatform.isx86_64) (
        mistral-rs.override { acceleration = "mkl"; }
      );
      withCuda = lib.optionalAttrs hostPlatform.isLinux (mistral-rs.override { acceleration = "cuda"; });
      withMetal = lib.optionalAttrs (hostPlatform.isDarwin && hostPlatform.isAarch64) (
        mistral-rs.override { acceleration = "metal"; }
      );
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Blazingly fast LLM inference";
    homepage = "https://github.com/EricLBuehler/mistral.rs";
    changelog = "https://github.com/EricLBuehler/mistral.rs/releases/tag/v${finalAttrs.version}";
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
})
