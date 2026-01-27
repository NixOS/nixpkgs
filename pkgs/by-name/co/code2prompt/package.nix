{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  perl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "code2prompt";
  version = "4.0.2";

  src = fetchFromGitHub {
    owner = "mufeedvh";
    repo = "code2prompt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2ac/ZobL+4cQz94JjtS+JC7qsPE5lktznlhMAgSJa8g=";
  };

  cargoHash = "sha256-e9GW/eAxO3pE4BUCT0uq1GOefRNhEFDCOFnoB7DIbEU=";

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "CLI tool that converts your codebase into a single LLM prompt with a source tree, prompt templating, and token counting";
    homepage = "https://github.com/mufeedvh/code2prompt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ heisfer ];
    mainProgram = "code2prompt";
  };
})
