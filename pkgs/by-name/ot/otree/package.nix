{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "otree";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "fioncat";
    repo = "otree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7Yv8krhtA+YAbJmF/bxgWb6NZBzg/fubxkzDEeOw4xU=";
  };

  cargoHash = "sha256-Op0IIH1whnBWP5Z5LLygdiWpysC/JZJEKX6OLHQAsWo=";

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
