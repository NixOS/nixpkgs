{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "humanshell";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "juanparati";
    repo = "humanshell";
    rev = version;
    hash = "sha256-RoH9tXgefL4woXmKrXCX19O4iVWQvgi23r4UsG6ysFc=";
  };

  cargoHash = "sha256-u2++3IgDg8xZHPDgfSODLwHvVRXsfiNKeL+E0fXpOI0=";

  meta = {
    description = "Translate human expressions into shell expressions";
    homepage = "https://github.com/juanparati/humanshell";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ juanparati ];
    platforms = lib.platforms.unix;
    longDescription = ''
      A command-line tool that translates human expressions into shell commands
      using the Anthropic API and Open AI API.
    '';
    mainProgram = "hs";
  };
}
