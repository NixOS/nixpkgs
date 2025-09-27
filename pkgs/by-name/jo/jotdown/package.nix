{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "jotdown";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "hellux";
    repo = "jotdown";
    rev = version;
    hash = "sha256-9gvTMcoKGdc6xYhGz1SQzTELUWeIK2VFbEwIVn/IjGs=";
  };

  cargoHash = "sha256-x61oImdXsLD/lU4hNcrQ2rjH5hAvTMEDJn4H3cVG6X4=";

  meta = with lib; {
    description = "Minimal Djot CLI";
    mainProgram = "jotdown";
    homepage = "https://github.com/hellux/jotdown";
    changelog = "https://github.com/hellux/jotdown/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
