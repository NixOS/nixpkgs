{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-temp";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "yozhgoor";
    repo = "cargo-temp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ILkv6axwyOneJAD/gvO24vh1J1F8XtwZzmsx6WU7DJQ=";
  };

  cargoHash = "sha256-ziHwGU2+qENsm/UuT9ZxzPVonwn8ldG8o+iWDaZIfw0=";

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
