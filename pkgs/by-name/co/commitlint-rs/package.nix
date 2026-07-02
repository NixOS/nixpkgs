{
  lib,
  commitlint-rs,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "commitlint-rs";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "KeisukeYamashita";
    repo = "commitlint-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Z9DQfUXYjPWMfCv2jHsXwr3Fg2tEfkD5dU1t8+Kw7eA=";
  };

  cargoHash = "sha256-s8prPnyiYCyaR+jMo1DXpBi9FgD/2ovF3dffZQuMNmo=";

  passthru = {
    tests.version = testers.testVersion { package = commitlint-rs; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Lint commit messages with conventional commit messages";
    homepage = "https://keisukeyamashita.github.io/commitlint-rs";
    changelog = "https://github.com/KeisukeYamashita/commitlint-rs/releases/tag/${finalAttrs.src.rev}";
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
})
