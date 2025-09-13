{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-supply-chain";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "rust-secure-code";
    repo = "cargo-supply-chain";
    rev = "v${version}";
    hash = "sha256-LTr7Y1SHk56ltYAA6AESAiWD0Rr15cY1BtOyhM4Q5iE=";
  };

  cargoHash = "sha256-Lk08Avmx563A2Ka5J/TqxY3FRNgbKRSsIpJWYlcLt0E=";

  meta = with lib; {
    description = "Gather author, contributor and publisher data on crates in your dependency graph";
    mainProgram = "cargo-supply-chain";
    homepage = "https://github.com/rust-secure-code/cargo-supply-chain";
    changelog = "https://github.com/rust-secure-code/cargo-supply-chain/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
      zlib
    ]; # any of three
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
