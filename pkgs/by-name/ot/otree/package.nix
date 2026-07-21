{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "otree";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "fioncat";
    repo = "otree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kcdhppc1hdPCQ+Q0ogmGSS9skC+ql96WQgCgKMBKcss=";
  };

  cargoHash = "sha256-B72PRaCMF4jEvsoUJyGFRNnA0ok3UYZfIwU/MAiWMJo=";

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
