{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jotdown";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "hellux";
    repo = "jotdown";
    rev = finalAttrs.version;
    hash = "sha256-76GYcLgTmTAweV+SI93me89YUHAujE0dFetG5QLlFRs=";
  };

  cargoHash = "sha256-1h7nL37OtqHMLO7W1DHPo2SH7prGqHlDgMHbTQu0gBI=";

  meta = {
    description = "Minimal Djot CLI";
    mainProgram = "jotdown";
    homepage = "https://github.com/hellux/jotdown";
    changelog = "https://github.com/hellux/jotdown/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
