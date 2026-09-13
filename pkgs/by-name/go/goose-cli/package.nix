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
  version = "1.49.0";

  src = fetchFromGitHub {
    owner = "aaif-goose";
    repo = "goose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KTHfaPJ3Vf2b6efMr0k9/AAMykDaG0lgSVCUpL58fnk=";
  };

  cargoHash = "sha256-78E/J64RIy7AkFODLVQBFy8HPUtT2ODLwNAstErRMdQ=";

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
    # the mock provider can finish before the polling loop observes an active run
    "--skip=test_steer_session_adds_input_to_active_prompt"
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
