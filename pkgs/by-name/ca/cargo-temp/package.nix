{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-temp";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "yozhgoor";
    repo = "cargo-temp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5GTsVqQOS0HL2q++t4ms9srFx1t1DJkdyUx150H6CT0=";
  };

  cargoHash = "sha256-wiFEsnBHFaQH7WyJv5FEEWXPiRfFFWm8NUjd0ea05Ko=";

  meta = {
    description = "CLI tool that allow you to create a temporary new Rust project using cargo with already installed dependencies";
    mainProgram = "cargo-temp";
    homepage = "https://github.com/yozhgoor/cargo-temp";
    changelog = "https://github.com/yozhgoor/cargo-temp/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
