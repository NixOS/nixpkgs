{
  lib,
  fetchFromGitHub,
  pkg-config,
  gitMinimal,
  rustPlatform,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-metrics";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "jdrouet";
    repo = "git-metrics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z34yzKHoTskIDPWl9LHy9dsXeNxwlI6kD73EzeSUrN0=";
  };

  cargoHash = "sha256-7/1Jf3GJmEydTDVL3oGIKIkCHAMKJ8BE6PUmpWH0xcQ=";

  buildInputs = [
    openssl
  ];

  nativeCheckInputs = [
    pkg-config
    gitMinimal
  ];

  checkFlags = [
    # requires git author information to be detectable
    "--skip=tests::check_budget::execute::with_command_backend"
    "--skip=tests::check_budget::execute::with_git2_backend"
    "--skip=tests::conflict_different::execute::with_command_backend"
    "--skip=tests::conflict_different::execute::with_git2_backend"
    "--skip=tests::display_diff::execute"
    "--skip=tests::simple_use_case::execute::with_command_backend"
    "--skip=tests::simple_use_case::execute::with_git2_backend"
    "--skip=tests::config_override"
  ];

  passthru.updateScript = nix-update-script { };

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/jdrouet/git-metrics";
    changelog = "https://github.com/jdrouet/git-metrics/releases/tag/v${finalAttrs.version}";
    description = "Git extension to be able to track metrics about your project, within the git repository";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "git-metrics";
  };
})
