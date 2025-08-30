{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "otree";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "fioncat";
    repo = "otree";
    tag = "v${version}";
    hash = "sha256-Pz9iAN5GMJeYYQ7T0QWUfRwvSfreRF8pJR8ctPVFAmA=";
  };

  cargoHash = "sha256-Uz4oA8maAiUye+FRoVBRuMHoPytr5y8DUfPA4CuMSe4=";

  meta = {
    description = "Command line tool to view objects (JSON/YAML/TOML/XML) in TUI tree widget";
    homepage = "https://github.com/fioncat/otree";
    changelog = "https://github.com/fioncat/otree/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "otree";
    maintainers = with lib.maintainers; [
      anas
      kiara
    ];
  };
}
