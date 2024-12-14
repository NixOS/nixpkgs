{
  fetchFromGitHub,
  gitUpdater,
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "hatsu";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "importantimport";
    repo = "hatsu";
    rev = "refs/tags/v${version}";
    hash = "sha256-K+8X/bNPdjxBSJdlFIXUUOXlTq7Cgol3fFToj5KzbeE=";
  };

  cargoHash = "sha256-+fNFy3WnQKtDjpNU3veoR2JrBNHj6/Wz2MQP38SR23I=";

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    ignoredVersions = "beta";
  };

  meta = {
    description = "Self-hosted and fully-automated ActivityPub bridge for static sites";
    homepage = "https://github.com/importantimport/hatsu";
    changelog = "https://github.com/importantimport/hatsu/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "hatsu";
    maintainers = with lib.maintainers; [ kwaa ];
    platforms = lib.platforms.linux;
  };
}
