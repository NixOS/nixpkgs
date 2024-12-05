{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "otree";
  version = "v0.3.0";

  src = fetchFromGitHub {
    owner = "fioncat";
    repo = "otree";
    rev = version;
    hash = "sha256-WvoiTu6erNI5Cb9PSoHgL6+coIGWLe46pJVXBZHOLTE=";
  };

  cargoHash = "sha256-2eFGTpI4yevcxtgtGH+AufMDqsuhOH9CiyXUpjtdTDE=";

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
