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
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "mufeedvh";
    repo = "code2prompt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Gh8SsSTZW7QlyyC3SWJ5pOK2x85/GT7+LPJn2Jeczpc=";
  };

  cargoHash = "sha256-t4HpGqojIkw9OBUAYz4ZEaB7XyHQxkFB2HtlkGKbe2s=";

  nativeBuildInputs = [
    pkg-config
    perl
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
