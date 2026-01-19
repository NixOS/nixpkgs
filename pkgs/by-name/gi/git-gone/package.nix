{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "git-gone";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "swsnr";
    repo = "git-gone";
    tag = "v${version}";
    hash = "sha256-/8ujbZ7FQTZzTG4HnHg6v3rWhxt2PuSGwIJpBVTxhfM=";
  };

  cargoHash = "sha256-93nZhZOtti28FetuOYtvh6LOtQJV+cEHbOkrJ+3m1m4=";

  meta = {
    description = "Cleanup stale Git branches of merge requests";
    homepage = "https://github.com/swsnr/git-gone";
    changelog = "https://github.com/swsnr/git-gone/raw/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      cafkafk
      matthiasbeyer
    ];
    mainProgram = "git-gone";
  };
}
