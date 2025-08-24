{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "otree";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "fioncat";
    repo = "otree";
    tag = "v${version}";
    hash = "sha256-nfRCqqOJl5tpKFyWAHa98Z1Q2lD61eFPD3O155mawf8=";
  };

  cargoHash = "sha256-+rBS9t743OwfNCy6v5dRdjWZRHA5GNniaWVnAtb5yaw=";

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
