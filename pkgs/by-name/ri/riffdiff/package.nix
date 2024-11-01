{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  riffdiff,
  testers,
}:

rustPlatform.buildRustPackage rec {
  pname = "riffdiff";
  version = "3.3.3";

  src = fetchFromGitHub {
    owner = "walles";
    repo = "riff";
    rev = "refs/tags/${version}";
    hash = "sha256-IdYQ8vD3ZIzqdNY4JtR8f2huV/DWOhV8FUn7tuRe7IQ=";
  };

  cargoHash = "sha256-1on4CTstEvjNLtk1RG6dcNl0XhaPYAy+U0DYn/aVzEg=";

  passthru = {
    tests.version = testers.testVersion { package = riffdiff; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Diff filter highlighting which line parts have changed";
    homepage = "https://github.com/walles/riff";
    changelog = "https://github.com/walles/riff/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ johnpyp ];
    mainProgram = "riff";
  };
}
