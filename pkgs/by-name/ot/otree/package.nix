{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "otree";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "fioncat";
    repo = "otree";
    tag = "v${version}";
    hash = "sha256-A4UY3SRahpxl6xqJuamXlBenemJuvFS6KcHKOXEHDyw=";
  };

  cargoHash = "sha256-cePX4Uxu7BOsB1JIGAsDfiOLeVAgL+0Lnst4shtpEX4=";

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
