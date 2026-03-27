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

  minRequiredCudaCapability = "8.0"; # build fails with 7.5
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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "EricLBuehler";
    repo = "mistral.rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2gE3LRm2oy6H+y6dRNnwYIjlaG67it16bfhfTk4CUTc=";
  };

  patches = [
    ./no-native-cpu.patch
  ];

  postPatch =
    # LTO significantly increases the build time (12m -> 1h)
    ''
      substituteInPlace Cargo.toml \
        --replace-fail \
          "lto = true" \
          "lto = false"
    '';

  cargoHash = "sha256-nktoMh07PfGJ156XrKa1N/icB634cr9ybsHq/y9zHKo=";

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
    # metal (proprietary) is not available in the darwin sandbox.
    # Hence, we must disable metal precompilation.
    MISTRALRS_METAL_PRECOMPILE = 0;

    SWAGGER_UI_DOWNLOAD_URL =
      let
        # When updating:
        # - Look for the version of `utoipa-swagger-ui` at:
        #   https://github.com/EricLBuehler/mistral.rs/blob/v<MISTRAL-RS-VERSION>/Cargo.toml
        # - Look at the corresponding version of `swagger-ui` at:
        #   https://github.com/juhaku/utoipa/blob/utoipa-swagger-ui-<UTOPIA-SWAGGER-UI-VERSION>/utoipa-swagger-ui/build.rs#L21-L22
        swaggerUiVersion = "5.17.14";

        swaggerUi = fetchurl {
          url = "https://github.com/swagger-api/swagger-ui/archive/refs/tags/v${swaggerUiVersion}.zip";
          hash = "sha256-SBJE0IEgl7Efuu73n3HZQrFxYX+cn5UU5jrL4T5xzNw=";
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
  # See https://github.com/juhaku/utoipa/blob/utoipa-swagger-ui-9.0.2/utoipa-swagger-ui/build.rs#L168
  # Not deleting the existing unpacked archive leads to a `PermissionDenied` error
  preCheck = ''
    rm -rf target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/build/
  '';

  # Prevent checkFeatures from inheriting buildFeatures because
  # - `cargo check ... --features=cuda` requires access to a real GPU
  # - `cargo check ... --features=metal` (on darwin) requires the sandbox to be completely disabled
  checkFeatures = [ ];

  checkFlags = [
    # Try to access internet
    "--skip=gguf::gguf_tokenizer::tests::test_encode_decode_gpt2"
    "--skip=gguf::gguf_tokenizer::tests::test_encode_decode_llama"
    "--skip=util::tests::test_parse_image_url"
    "--skip=utils::tiktoken::tests::test_tiktoken_conversion"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  # When started, mistralrs tries to load libcuda.so from the driver which is not available in the sandbox
  # mistralrs: error while loading shared libraries: libcuda.so.1: cannot open shared object file: No such file or directory
  doInstallCheck = !cudaSupport;

  passthru = {
    tests = {
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
    mainProgram = "mistralrs";
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
