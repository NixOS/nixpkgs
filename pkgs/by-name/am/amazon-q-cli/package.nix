{
  lib,
  fetchFromGitHub,
  rustPlatform,
  protobuf_26,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "amazon-q-cli";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "amazon-q-developer-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BiVCiMBL5LLm8RYw58u6P7yqQq9XnN8b6fTbxNE2QsA=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-7zUgWLGTZx3Ex7RYxb3eZimWdy6AxkNwpCDUwiAr2JE=";

  cargoBuildFlags = [
    "-p"
    "q_cli"
  ];

  nativeBuildInputs = [
    protobuf_26
  ];

  postInstall = ''
    install -m 0755 $out/bin/q_cli $out/bin/amazon-q
  '';

  cargoTestFlags = [
    "-p"
    "q_cli"
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
