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

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Gather author, contributor and publisher data on crates in your dependency graph";
    mainProgram = "cargo-supply-chain";
    homepage = "https://github.com/rust-secure-code/cargo-supply-chain";
    changelog = "https://github.com/rust-secure-code/cargo-supply-chain/blob/${src.rev}/CHANGELOG.md";
<<<<<<< HEAD
    license = with lib.licenses; [
=======
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      asl20
      mit
      zlib
    ]; # any of three
<<<<<<< HEAD
    maintainers = with lib.maintainers; [
=======
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      matthiasbeyer
    ];
  };
}
