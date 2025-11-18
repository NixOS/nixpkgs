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
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "block";
    repo = "goose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-61MFtAhz7yq2wStNWDIlBo+OubBVor0NnpOAX8nQ8K0=";
  };

  cargoHash = "sha256-YR/QUEE+EbwytiL0xkCr/EYE0O2/B/KmuLaF6TA7N6I=";

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
    "--skip=routes::audio::tests::test_transcribe_endpoint_requires_auth"
    "--skip=routes::config_management::tests::test_get_provider_models_openai_configured"
    # integration tests that need network access
    "--skip=test_replayed_session::vec_uvx_mcp_server_fetch_vec_calltoolrequestparam_name_fetch_into_arguments_some_object_url_https_example_com_vec_expects"
    "--skip=test_replayed_session::vec_github_mcp_server_stdio_vec_calltoolrequestparam_name_get_file_contents_into_arguments_some_object_owner_block_repo_goose_path_readme_md_sha_ab62b863c1666232a67048b6c4e10007a2a5b83c_vec_github_personal_access_token_expects"
    "--skip=test_replayed_session::vec_cargo_run_quiet_p_goose_server_bin_goosed_mcp_developer_vec_calltoolrequestparam_name_text_editor_into_arguments_some_object_command_view_path_goose_crates_goose_tests_tmp_goose_txt_calltoolrequestparam_name_text_editor_into_arguments_some_object_command_str_replace_path_goose_crates_goose_tests_tmp_goose_txt_old_str_goose_new_str_goose_modified_by_test_calltoolrequestparam_name_shell_into_arguments_some_object_command_cat_goose_crates_goose_tests_tmp_goose_txt_calltoolrequestparam_name_text_editor_into_arguments_some_object_command_str_replace_path_goose_crates_goose_tests_tmp_goose_txt_old_str_goose_modified_by_test_new_str_goose_calltoolrequestparam_name_list_windows_into_arguments_some_object_vec_expects"
    "--skip=test_replayed_session::vec_npx_y_modelcontextprotocol_server_everything_vec_calltoolrequestparam_name_echo_into_arguments_some_object_message_hello_world_calltoolrequestparam_name_add_into_arguments_some_object_a_1_b_2_calltoolrequestparam_name_longrunningoperation_into_arguments_some_object_duration_1_steps_5_calltoolrequestparam_name_structuredcontent_into_arguments_some_object_location_11238_vec_expects"
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    "--skip=context_mgmt::auto_compact::tests::test_auto_compact_respects_config"
    "--skip=scheduler::tests::test_scheduled_session_has_schedule_id"
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
      brittonr
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
