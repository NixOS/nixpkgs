{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,

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
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "EricLBuehler";
    repo = "mistral.rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6aEYCHXfIfzjeeD6icNxum7z7UZgeNAFw3tBNdhrg0I=";
  };

  patches = [
    ./no-native-cpu.patch
    # https://github.com/EricLBuehler/mistral.rs/pull/1510
    (fetchpatch {
      name = "fix-mcp-import-doc-string";
      url = "https://github.com/EricLBuehler/mistral.rs/commit/c25d1dbed00ea2442ec017c859754fd34c9e5ff5.patch";
      hash = "sha256-de+Xz/Md8816646a8lqJ1P4skDVXSvJAlUTwX1Mo25Y=";
    })
    # https://github.com/EricLBuehler/mistral.rs/pull/1511
    (fetchpatch {
      name = "fix-mcp-doc-string";
      url = "https://github.com/EricLBuehler/mistral.rs/commit/5fbf607a88c44e048be0598b368900ec4088bd5a.patch";
      hash = "sha256-WOf/JivdQfnbQPd8IS+qq+XoDFy4UKnfk0yD+D8WLeg=";
    })
    # https://github.com/EricLBuehler/mistral.rs/pull/1518
    (fetchpatch {
      name = "allow-disabling-metal-shaders-precompilation";
      url = "https://github.com/EricLBuehler/mistral.rs/commit/359f99c6fed31c4de0dbe61aaadf644070c6c4be.patch";
      hash = "sha256-2/sty8j9fpcmtD09oco/ZkFd+sfKRvqnzpOp6qPBLcU=";
    })
  ];

  postPatch =
    # LTO significantly increases the build time (12m -> 1h)
    ''
      substituteInPlace Cargo.toml \
        --replace-fail \
          "lto = true" \
          "lto = false"
    '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-gwotO786FcbK0TDuBrGAM1FVf4dV9RxZ+vrRC1mdyhE=";

  nativeBuildInputs =
    [
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

  buildInputs =
    [
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

  env =
    {
      # metal (proprietary) is not available in the darwin sandbox.
      # Hence, we must disable metal precompilation.
      MISTRALRS_METAL_PRECOMPILE = 0;

      SWAGGER_UI_DOWNLOAD_URL =
        let
          # When updating:
          # - Look for the version of `utoipa-swagger-ui` at:
          #   https://github.com/EricLBuehler/mistral.rs/blob/v<MISTRAL-RS-VERSION>/mistralrs-server/Cargo.toml
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

    "--skip=mistralrs-mcp/src/lib.rs"
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
