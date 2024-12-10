{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "ttyper";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "max-niederman";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-L6xdJ659ZWKNg9CGQs+5TQIKoIAZ5KHdFSk7NCp9a2Q=";
  };

  cargoHash = "sha256-iOeyn4oXk6y/NqZeBwkStBjt3hVVw4s2L5Lm58tq1BY=";

  meta = with lib; {
    description = "Terminal-based typing test";
    homepage = "https://github.com/max-niederman/ttyper";
    changelog = "https://github.com/max-niederman/ttyper/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      max-niederman
    ];
    mainProgram = "ttyper";
  };
}
