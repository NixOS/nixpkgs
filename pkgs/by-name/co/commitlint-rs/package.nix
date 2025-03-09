{
  lib,
  commitlint-rs,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "commitlint-rs";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "KeisukeYamashita";
    repo = "commitlint-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-9az7AJ4NXmisRZiCFTdHQBVatgEIdRuKU6ZEKVHEgnQ=";
  };

  cargoHash = "sha256-6Ur4s8bMSQR9mfh6apsocle6KDIsQ6gzU5luXH7BP7M=";

  passthru = {
    tests.version = testers.testVersion { package = commitlint-rs; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Lint commit messages with conventional commit messages";
    homepage = "https://keisukeyamashita.github.io/commitlint-rs";
    changelog = "https://github.com/KeisukeYamashita/commitlint-rs/releases/tag/${src.rev}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      croissong
      getchoo
    ];
    mainProgram = "commitlint";
    platforms = with lib.platforms; unix ++ windows;
  };
}
