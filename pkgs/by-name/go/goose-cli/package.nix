{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  dbus,
  libxcb,
  pkg-config,
  protobuf,
  openssl,
  cacert,
  gitMinimal,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
  llvmPackages,
  makeWrapper,
  librusty_v8 ? callPackage ./librusty_v8.nix {
    inherit (callPackage ./fetchers.nix { }) fetchLibrustyV8;
  },

  # Extension(s) Dependencies
  python3,
  bash,
  # X11
  xdotool,
  wmctrl,
  xclip,
  xwininfo,
  # Wayland
  wtype,
  wl-clipboard,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "goose-cli";
  version = "1.47.0";

  src = fetchFromGitHub {
    owner = "aaif-goose";
    repo = "goose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+sowkBtUbpBPAgi1Tn1WSgIac2yzCWsXcsh96Pp5VSY=";
  };

  cargoHash = "sha256-rJnhi14eKkYBK1rmQsRTb3lS2ChklOZ8mOA/H1iclh0=";

  cargoBuildFlags = [
    "--bin"
    "goose"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    rustPlatform.bindgenHook
    makeWrapper
  ];

  buildInputs = [
    dbus
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libxcb ];

  env = {
    LIBCLANG_PATH = "${lib.getLib llvmPackages.libclang}/lib";
    RUSTY_V8_ARCHIVE = librusty_v8;
  };

  postFixup = ''
    wrapProgram $out/bin/goose \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            bash
            python3
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            # X11
            xdotool
            wmctrl
            xclip
            xwininfo
            # Wayland
            wtype
            wl-clipboard
          ]
        )
      }
  '';

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    cacert
    # plugins tests create git-backed fixture repositories
    gitMinimal
  ];

  __darwinAllowLocalNetworking = true;

  checkFlags = [
    # need dbus-daemon for keychain access
    "--skip=config::base::tests::test_multiple_secrets"
    "--skip=config::base::tests::test_secret_management"
    "--skip=config::signup_tetrate::tests::test_configure_tetrate"
    # Observer should be Some with both init project keys set
    "--skip=tracing::langfuse_layer::tests::test_create_langfuse_observer"
    "--skip=providers::gcpauth::tests::test_token_refresh_race_condition"
    # need network access
    "--skip=test_concurrent_access"
    # these race on process-global state (GOOSE_PATH_ROOT / GOOSE_SHELL env
    # vars, OnceLock caches) when the lib tests run in parallel
    # https://github.com/aaif-goose/goose/issues/11059
    "--skip=hooks::tests::matcher_filters_by_tool_name"
    "--skip=plugins::discovery::tests::enabled_in_config_keeps_plugin_without_modifying_config"
    # the mock provider can finish before the polling loop observes an active run
    "--skip=test_steer_session_adds_input_to_active_prompt"
    # integration tests that need network access
    "--skip=test_replayed_session::vec_uvx_mcp_server_fetch_vec_calltoolrequestparam_name_fetch_into_arguments_some_object_url_https_example_com_vec_expects"
    "--skip=test_replayed_session::vec_github_mcp_server_stdio_vec_calltoolrequestparam_name_get_file_contents_into_arguments_some_object_owner_block_repo_goose_path_readme_md_sha_ab62b863c1666232a67048b6c4e10007a2a5b83c_vec_github_personal_access_token_expects"
    "--skip=test_replayed_session::vec_npx_y_modelcontextprotocol_server_everything_vec_calltoolrequestparam_name_echo_into_arguments_some_object_message_hello_world_calltoolrequestparam_name_add_into_arguments_some_object_a_1_b_2_calltoolrequestparam_name_longrunningoperation_into_arguments_some_object_duration_1_steps_5_calltoolrequestparam_name_structuredcontent_into_arguments_some_object_location_11238_vec_expects"
    # loopback_transport_does_not_use_environment_proxy sets HTTP_PROXY
    # process-wide; concurrent wiremock-based tests in the same binary pick it
    # up and fail with NetworkError. Remove once the fix lands upstream:
    # https://github.com/aaif-goose/goose/pull/11262
    "--skip=api_client::tests::loopback_transport_does_not_use_environment_proxy"
    "--skip=anthropic::tests::fetch_models_treats_invalid_json_as_endpoint_not_found"
    "--skip=anthropic::tests::fetch_models_treats_missing_data_field_as_request_failed"
    "--skip=anthropic::tests::fetch_supported_models_accepts_null_error"
    "--skip=anthropic::tests::fetch_supported_models_does_not_fall_back_on_missing_data"
    "--skip=anthropic::tests::fetch_supported_models_falls_back_on_invalid_payload"
    "--skip=anthropic::tests::fetch_supported_models_preserves_200_error_type"
    "--skip=anthropic::tests::fetch_supported_models_propagates_auth_error"
    "--skip=anthropic::tests::fetch_supported_models_propagates_auth_error_from_200_payload"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # Broken on aarch64-linux: request capture races across session_id_propagation_test cases
    "--skip=test_session_id_matches_across_calls"
    "--skip=test_session_id_propagation_to_llm"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=recipes::extract_from_cli::tests::test_extract_recipe_info_from_cli_basic"
    "--skip=recipes::extract_from_cli::tests::test_extract_recipe_info_from_cli_with_additional_sub_recipes"
    "--skip=recipes::recipe::tests::load_recipe::test_load_recipe_success"
    "--skip=test_session_id_matches_across_calls"
    "--skip=test_session_id_propagation_to_llm"
    # keychain-backed dictation secret test panics on empty swap_remove
    "--skip=test_custom_dictation_secret_save_delete"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source, extensible AI agent that goes beyond code suggestions - install, execute, edit, and test with any LLM";
    homepage = "https://github.com/aaif-goose/goose";
    changelog = "https://github.com/aaif-goose/goose/releases/tag/${finalAttrs.src.tag}";
    mainProgram = "goose";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      asiantuntija
      cloudripper
      thardin
      brittonr
      miniharinn
      caniko
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
