{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-temp";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "yozhgoor";
    repo = "cargo-temp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-F7KIYEWZN4KAVoBRquL7/VH0p+MSFGO0n2PkbXljyPM=";
  };

  cargoHash = "sha256-ho5HriiViW2FxxPz4RA1nCkmlG7cdt5VuhVrSdGzzuY=";

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
