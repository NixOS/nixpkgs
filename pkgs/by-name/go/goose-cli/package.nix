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
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "block";
    repo = "goose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZfS0U7PpGWWuqGKd7IjRaavqZSySx93F9S1d7r2wMkE=";
  };

  cargoHash = "sha256-uYgYzP75QkN1VksYL3KeNMNy7wb0TgCP8HPN1QrfZoo=";

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

  checkFlags = [
    # need dbus-daemon for keychain access
    "--skip=config::base::tests::test_multiple_secrets"
    "--skip=config::base::tests::test_secret_management"
    "--skip=config::base::tests::test_concurrent_extension_writes"
    "--skip=config::signup_tetrate::tests::test_configure_tetrate"
    # Observer should be Some with both init project keys set
    "--skip=tracing::langfuse_layer::tests::test_create_langfuse_observer"
    "--skip=providers::gcpauth::tests::test_token_refresh_race_condition"
    # need API keys
    "--skip=providers::factory::tests::test_create_lead_worker_provider"
    "--skip=providers::factory::tests::test_create_regular_provider_without_lead_config"
    "--skip=providers::factory::tests::test_lead_model_env_vars_with_defaults"
    # need network access
    "--skip=test_concurrent_access"
    "--skip=test_model_not_in_openrouter"
    "--skip=test_pricing_cache_performance"
    "--skip=test_pricing_refresh"
    "--skip=transport::streamable_http::tests::test_handle_outgoing_message_http_error"
    "--skip=transport::streamable_http::tests::test_handle_outgoing_message_invalid_json"
    "--skip=transport::streamable_http::tests::test_handle_outgoing_message_notification"
    "--skip=transport::streamable_http::tests::test_handle_outgoing_message_session_id_handling"
    "--skip=transport::streamable_http::tests::test_handle_outgoing_message_session_not_found"
    "--skip=transport::streamable_http::tests::test_handle_outgoing_message_successful_request"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--skip=context_mgmt::auto_compact::tests::test_auto_compact_respects_config"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=logging::tests::test_log_file_name_no_session"
    "--skip=recipes::extract_from_cli::tests::test_extract_recipe_info_from_cli_basic"
    "--skip=recipes::extract_from_cli::tests::test_extract_recipe_info_from_cli_with_additional_sub_recipes"
    "--skip=recipes::recipe::tests::load_recipe::test_load_recipe_success"
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
