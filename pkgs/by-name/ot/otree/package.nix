{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "otree";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "fioncat";
    repo = "otree";
    tag = "v${version}";
    hash = "sha256-l2hU1a2yfXo8u8wjSmvzL+nzniMQFKvdBhQ0eqqG3tg=";
  };

  cargoHash = "sha256-UyomqesHDaGDEBHVcQMwUI7kH8akOOuyXOL/r4gfiAo=";

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
