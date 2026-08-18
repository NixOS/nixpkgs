{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-xwin";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "rust-cross";
    repo = "cargo-xwin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JQYAYCCN/dWvX1oqFX/MjvtPuCA3k8WbHmmGBxG9ylA=";
  };

  cargoHash = "sha256-FRK4bCTPAPWGov8vEFr9XdqCNoeXeyFdyiWV5x+4WYY=";

  meta = {
    description = "Cross compile Cargo project to Windows MSVC target with ease";
    mainProgram = "cargo-xwin";
    homepage = "https://github.com/rust-cross/cargo-xwin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shivaraj-bh ];
  };
})
