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
  writeShellScript,
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
  version = "1.53.0";

  src = fetchFromGitHub {
    owner = "aaif-goose";
    repo = "goose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NoJFwEd4kNGASEo7+E/jRG192oV0hZs3PISi5hG3Q4Q=";
  };

  cargoHash = "sha256-zQc2/t+KEHee7twcpRquhgVP8ZywoMz8w7uHwi9uW8U=";

  cargoBuildFlags = [
    "--bin"
    "goose"
  ];

  # The cwd test (since upstream #11501) symlinks /bin/pwd, which the Linux
  # sandbox doesn't have. Point it at a store script instead; coreutils' pwd
  # won't do, as it's a multicall binary that dispatches on argv[0].
  postPatch = ''
    substituteInPlace crates/goose/src/providers/command_auth.rs \
      --replace-fail '"/bin/pwd"' '"${writeShellScript "print-cwd" "pwd"}"'
  '';

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
    # the mock provider can finish before the polling loop observes an active run
    "--skip=test_steer_session_adds_input_to_active_prompt"
    # otel span capture races with other tests' global tracing subscribers
    # when the lib tests run in parallel
    "--skip=agents::agent::tests::tool_dispatch_records_gen_ai_span_attributes"
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
    # goose-roaming: iroh tests segfault on aarch64-darwin
    "--skip=trust_file_refresh_takes_effect_on_running_share"
    "--skip=accepted_key_connects_and_streams"
    "--skip=unaccepted_key_is_rejected"
    "--skip=revoked_key_is_rejected"
    "--skip=revocation_closes_live_connection"
    "--skip=revocation_watcher_closes_live_connection_from_file"
    "--skip=relay_to_direct_upgrade_loses_no_data"
    "--skip=concurrent_dial_burst"
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
