{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "amazon-q-cli";
  version = "1.12.1";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-q-developer-cli-autocomplete";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oY2hDOsws2WVQPKEFhGNPHITo26p/UZ5XzvRX7DoMyc=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-xriK88OY6W1cOZVgiUPBIuItVHwEyFNq5Ywh367K6CU=";

  cargoBuildFlags = [
    "-p"
    "chat_cli"
  ];

  postInstall = ''
    install -m 0755 $out/bin/chat_cli $out/bin/amazon-q
    rm -f $out/bin/chat_cli $out/bin/test_mcp_server
  '';

  cargoTestFlags = [
    "-p"
    "chat_cli"
  ];

  # skip integration tests that have external dependencies
  checkFlags = [
    "--skip=cli::chat::tests::test_flow"
    "--skip=cli::init::tests::test_prompts"
    "--skip=debug_get_index"
    "--skip=debug_list_intellij_variants"
    "--skip=debug_refresh_auth_token"
    "--skip=local_state_all"
    "--skip=local_state_get"
    "--skip=settings_all"
    "--skip=settings_get"
    "--skip=user_whoami"
    "--skip=init_lint_bash_post_bash_profile"
    "--skip=init_lint_bash_post_bashrc"
    "--skip=init_lint_bash_pre_bash_profile"
    "--skip=init_lint_bash_pre_bashrc"
    "--skip=init_lint_fish_pre_00_fig_pre"
    "--skip=init_lint_zsh_post_zprofile"
    "--skip=init_lint_zsh_post_zshrc"
    "--skip=init_lint_zsh_pre_zprofile"
    "--skip=init_lint_zsh_pre_zshrc"
    "--skip=telemetry::cognito::test::pools"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/amazon-q";
  versionCheckProgramArg = "--version";

  meta = {
    description = "Amazon Q Developer AI coding agent CLI";
    homepage = "https://github.com/aws/amazon-q-developer-cli";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "amazon-q";
    maintainers = [ lib.maintainers.jamesward ];
    platforms = lib.platforms.linux;
  };
})
