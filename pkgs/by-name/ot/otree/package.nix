{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "otree";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "fioncat";
    repo = "otree";
    tag = "v${version}";
    hash = "sha256-zsBHra8X1nM8QINaxi3Vcs82T8S5WtfNRN5vb/ppuLU=";
  };

  cargoHash = "sha256-Ncyj5s4EfbKsFGV29FDViK35nKOAZM+DODzIVRCpbuQ=";

  meta = {
    description = "Command line tool to view objects (json/yaml/toml) in TUI tree widget";
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
