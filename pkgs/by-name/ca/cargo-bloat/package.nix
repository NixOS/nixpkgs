{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-bloat";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "RazrFalcon";
    repo = "cargo-bloat";
    rev = "v${finalAttrs.version}";
    hash = "sha256-B71VX7cJe1giOLmk3cQE8Zxr7fKGyQkoXRuM+NzBcb8=";
  };

  cargoHash = "sha256-8Omw8IsmoFYPBB6q1EAAbcBhTjBWfCChV2MhX9ImY8Y=";

  meta = {
    description = "Tool and Cargo subcommand that helps you find out what takes most of the space in your executable";
    homepage = "https://github.com/RazrFalcon/cargo-bloat";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      xrelkd
      matthiasbeyer
    ];
    mainProgram = "cargo-bloat";
  };
})
