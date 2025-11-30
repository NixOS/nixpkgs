{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "cmdman";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "nusendra";
    repo = "cmdman";
    rev = "v0.1.0";
    hash = "sha256-e0DY9PHm3i+96d6s9VLQemwLAXkBqQCKB+3I4Il6zyI=";
  };

  cargoHash = "sha256-vFmnllS5LcyqRSc9VsI1PbYPxwnIB1gjYx/a7nHIq6Y=";

  meta = with lib; {
    description = "A CLI tool to save, manage, and execute custom commands with named aliases";
    homepage = "https://github.com/nusendra/cmdman";
    changelog = "https://github.com/nusendra/cmdman/releases/tag/v0.1.0";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "cmdman";
  };
}
