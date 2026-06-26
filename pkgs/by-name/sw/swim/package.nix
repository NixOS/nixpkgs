{
  lib,
  rustPlatform,
  fetchFromGitLab,
  pkg-config,
  openssl,
  spade,
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "swim";
  version = "0.19.0";

  src = fetchFromGitLab {
    owner = "spade-lang";
    repo = "swim";
    rev = "v${version}";
    hash = "sha256-5/yIucyErZpY5iN/6r8JNAfsrYPxh+lBHDBD6cnjbHQ=";
  };

  cargoHash = "sha256-+znzedDuB7hMzaRtAvLNUC9gG0Q2R8Fn61D64udAyAM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ];

  nativeCheckInputs = [
    git
    spade
  ];

  checkFlags = [
    # tries to find git after clearing environ
    "--skip=init::tests::git_init_then_swim_init_works"
    # tries to clone https://gitlab.com/spade-lang/swim-templates
    "--skip=init::tests::init_board_correctly_sets_project_name"
    "--skip=init::tests::init_board_creates_required_files"
    "--skip=plugin::test::deny_changes_to_plugins::edits_are_denied"
    "--skip=plugin::test::deny_changes_to_plugins::restores_work"
  ];

  passthru = {
    inherit (spade) updateScript;
  };

  meta = {
    description = "Build tool for spade";
    homepage = "https://gitlab.com/spade-lang/swim";
    changelog = "https://gitlab.com/spade-lang/swim/-/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ pbsds ];
    mainProgram = "swim";
  };
}
