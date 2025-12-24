{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "code2prompt";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "mufeedvh";
    repo = "code2prompt";
    rev = "v${version}";
    hash = "sha256-Gh8SsSTZW7QlyyC3SWJ5pOK2x85/GT7+LPJn2Jeczpc=";
  };

  cargoHash = "sha256-t4HpGqojIkw9OBUAYz4ZEaB7XyHQxkFB2HtlkGKbe2s=";

  cargoBuildFlags = [
    "-p"
    "code2prompt"
  ];

  OPENSSL_NO_VENDOR = 1;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = {
    description = "CLI tool that converts your codebase into a single LLM prompt with a source tree, prompt templating, and token counting";
    homepage = "https://github.com/mufeedvh/code2prompt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ heisfer ];
    mainProgram = "code2prompt";
  };
}
