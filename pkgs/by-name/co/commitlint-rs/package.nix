{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  testers,
  commitlint-rs,
}:
rustPlatform.buildRustPackage rec {
  pname = "commitlint-rs";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "KeisukeYamashita";
    repo = "commitlint-rs";
    rev = "v${version}";
    hash = "sha256-FrYXEh75H0u1rE1YNDL/B1gMYMG43jPDJGUMv9y5/3g=";
  };
  cargoHash = "sha256-W6HkLCUoylgQQc2fFprmJeLH8KtpVUD4+BXWbNECVZ4=";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = commitlint-rs; };
  };

  meta = with lib; {
    description = "Lint commit messages with conventional commit messages";
    homepage = "https://keisukeyamashita.github.io/commitlint-rs";
    changelog = "https://github.com/KeisukeYamashita/commitlint-rs/releases/tag/${src.rev}";
    license = with licenses; [
      mit
      asl20
    ];
    mainProgram = "commitlint";
    platforms = with platforms; unix ++ windows;
    maintainers = with maintainers; [
      croissong
      getchoo
    ];
  };
}
