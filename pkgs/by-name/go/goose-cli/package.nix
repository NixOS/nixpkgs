{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  dbus,
  xorg,
  pkg-config,
  protobuf,
  writableTmpDirAsHomeHook,
  nix-update-script,
  llvmPackages,
}:

let
  gpt-4o-tokenizer = fetchurl {
    url = "https://huggingface.co/Xenova/gpt-4o/resolve/31376962e96831b948abe05d420160d0793a65a4/tokenizer.json";
    hash = "sha256-Q6OtRhimqTj4wmFBVOoQwxrVOmLVaDrgsOYTNXXO8H4=";
    meta.license = lib.licenses.mit;
  };
  claude-tokenizer = fetchurl {
    url = "https://huggingface.co/Xenova/claude-tokenizer/resolve/cae688821ea05490de49a6d3faa36468a4672fad/tokenizer.json";
    hash = "sha256-wkFzffJLTn98mvT9zuKaDKkD3LKIqLdTvDRqMJKRF2c=";
    meta.license = lib.licenses.mit;
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "goose-cli";
  version = "1.0.30";

  src = fetchFromGitHub {
    owner = "block";
    repo = "goose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mhscs7yv3/FmJ/v1W0xcHya82ztrYGVULrtMyq4W4BY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-TNmeu0nQHTFnbe7CY5b58ysN6+iMD6yFTktr4gjKNY0=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [ dbus ] ++ lib.optionals stdenv.hostPlatform.isLinux [ xorg.libxcb ];

  env.LIBCLANG_PATH = "${lib.getLib llvmPackages.libclang}/lib";

  preBuild = ''
    mkdir -p tokenizer_files/Xenova--gpt-4o tokenizer_files/Xenova--claude-tokenizer
    ln -s ${gpt-4o-tokenizer} tokenizer_files/Xenova--gpt-4o/tokenizer.json
    ln -s ${claude-tokenizer} tokenizer_files/Xenova--claude-tokenizer/tokenizer.json
  '';

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  __darwinAllowLocalNetworking = true;

  checkFlags =
    [
      # need dbus-daemon
      "--skip=config::base::tests::test_multiple_secrets"
      "--skip=config::base::tests::test_secret_management"
      "--skip=config::base::tests::test_concurrent_extension_writes"
      # Observer should be Some with both init project keys set
      "--skip=tracing::langfuse_layer::tests::test_create_langfuse_observer"
      "--skip=providers::gcpauth::tests::test_token_refresh_race_condition"
      # Lazy instance has previously been poisoned
      "--skip=jetbrains::tests::test_capabilities"
      "--skip=jetbrains::tests::test_router_creation"
      "--skip=logging::tests::test_log_file_name::with_session_name_and_error_capture"
      "--skip=logging::tests::test_log_file_name::with_session_name_without_error_capture"
      "--skip=logging::tests::test_log_file_name::without_session_name"
      "--skip=developer::tests::test_text_editor_str_replace"
      # need API keys
      "--skip=providers::factory::tests::test_create_lead_worker_provider"
      "--skip=providers::factory::tests::test_create_regular_provider_without_lead_config"
      "--skip=providers::factory::tests::test_lead_model_env_vars_with_defaults"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "--skip=providers::gcpauth::tests::test_load_from_metadata_server"
      "--skip=providers::oauth::tests::test_get_workspace_endpoints"
      "--skip=tracing::langfuse_layer::tests::test_batch_manager_spawn_sender"
      "--skip=tracing::langfuse_layer::tests::test_batch_send_partial_failure"
      "--skip=tracing::langfuse_layer::tests::test_batch_send_success"
    ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source, extensible AI agent that goes beyond code suggestions - install, execute, edit, and test with any LLM";
    homepage = "https://github.com/block/goose";
    mainProgram = "goose";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      cloudripper
      thardin
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
