{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jotdown";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "hellux";
    repo = "jotdown";
    rev = finalAttrs.version;
    hash = "sha256-GUETWMWNAPfTcuu7LBgexgd1CWFbSyBwBZtFjMQ67Hk=";
  };

  cargoHash = "sha256-yuzjyP1iy6pgUJev1dJPjU85A3W5n7G2B+Pa1R47KiQ=";

  meta = {
    description = "Minimal Djot CLI";
    mainProgram = "jotdown";
    homepage = "https://github.com/hellux/jotdown";
    changelog = "https://github.com/hellux/jotdown/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
