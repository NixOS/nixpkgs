{
  lib,
  fetchFromGitHub,
  pkg-config,
  gitMinimal,
  rustPlatform,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-metrics";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "jdrouet";
    repo = "git-metrics";
    tag = "v${version}";
    hash = "sha256-SdA/FpdrbC36Ny7aBpTUvFldbYXyajSqWGheaDPHYoE=";
  };

  cargoHash = "sha256-e4CdpwoFl8leV5HJWkWBpvPrVrk+7vq49yTPkpeQ2Ng=";

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
  ];

  meta = {
    homepage = "https://github.com/jdrouet/git-metrics";
    description = "Git extension to be able to track metrics about your project, within the git repository";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "git-metrics";
  };
}
