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
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "KeisukeYamashita";
    repo = "commitlint-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-rNCMvIVJ/aOTNMyAmwX3Ir6IjHf6wxZ1XlGIWp7omkQ=";
  };

  cargoHash = "sha256-+MPHEkL5/+yR5+aKTDTaVO9D/v2xccwSo7clo20H1G0=";

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
