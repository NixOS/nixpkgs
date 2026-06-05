{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "otree";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "fioncat";
    repo = "otree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w3ZS3hg9hrqjYcNKacT86llhz7PzJbz1r7/bDJJWxxs=";
  };

  cargoHash = "sha256-S7ZG+p9grgqb5O7QqPdDUyhJnRWnPpCCDonyLQEznxc=";

  meta = {
    description = "Command line tool to view objects (JSON/YAML/TOML/XML) in TUI tree widget";
    homepage = "https://github.com/fioncat/otree";
    changelog = "https://github.com/fioncat/otree/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "otree";
    maintainers = with lib.maintainers; [
      anas
      kiara
    ];
  };
})
