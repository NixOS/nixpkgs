{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-temp";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "yozhgoor";
    repo = "cargo-temp";
    rev = "v${version}";
    hash = "sha256-kCiw3a9C78mcJ2/bX+E5gXZKYcfLXF0crMIZu4cJsdY=";
  };

  cargoHash = "sha256-7S7L/OKHTOAP9tbM7+xWhvcYBZScvX6SBW3U1AyFGrs=";

  meta = with lib; {
    description = "CLI tool that allow you to create a temporary new Rust project using cargo with already installed dependencies";
    mainProgram = "cargo-temp";
    homepage = "https://github.com/yozhgoor/cargo-temp";
    changelog = "https://github.com/yozhgoor/cargo-temp/releases/tag/${src.rev}";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [
      matthiasbeyer
    ];
  };
}
