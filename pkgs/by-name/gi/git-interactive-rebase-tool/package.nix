{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-interactive-rebase-tool";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "MitMaro";
    repo = "git-interactive-rebase-tool";
    rev = version;
    hash = "sha256-NlnESZua4OP7rhMoER/VgBST9THqISQ0LCG1ZakNTqs=";
  };

  cargoHash = "sha256-WTg1o2iF5/UOVIqKFqGbC28B4HrKJWM0+XCHgaA1lc4=";

  # Compilation during tests fails if this env var is not set.
  preCheck = "export GIRT_BUILD_GIT_HASH=${version}";
  postCheck = "unset GIRT_BUILD_GIT_HASH";

  meta = {
    homepage = "https://github.com/MitMaro/git-interactive-rebase-tool";
    description = "Native cross platform full feature terminal based sequence editor for git interactive rebase";
    changelog = "https://github.com/MitMaro/git-interactive-rebase-tool/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      SuperSandro2000
      zowoq
      ma27
    ];
    mainProgram = "interactive-rebase-tool";
  };
}
