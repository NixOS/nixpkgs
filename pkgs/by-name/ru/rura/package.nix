{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rura";
  version = "1.7.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tlipinski";
    repo = "rura";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rz8Hmxse1THGH3inGP3K+7JY3Lh9qaGUdESSHkai82c=";
  };

  cargoHash = "sha256-Ytbo8fVf6oAHGQvicU3TFGQxoYh36CISuRaMwd1Ysf4=";

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "Interactive TUI scratchpad for building shell pipelines";
    homepage = "https://github.com/tlipinski/rura";
    changelog = "https://github.com/tlipinski/rura/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ frantathefranta ];
    mainProgram = "rura";
  };
})
