{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-xwin";
  version = "0.21.5";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RgR0YBjgpk10IS62+/CdIbZ+7oSnkOC5npIqRrib6eU=";
  };

  cargoHash = "sha256-dJkfEPRyXFpMwqExvyimLMc+iOAby5yeEUpHt0MoQ6M=";

  meta = {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ shivaraj-bh ];
  };
})
