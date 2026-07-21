{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-fuzz";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "rust-fuzz";
    repo = "cargo-fuzz";
    tag = finalAttrs.version;
    hash = "sha256-DIvbxyIkmrxcFOpH0iZJGxJB60Bh5sjZX+kYUxpp/iQ=";
  };

  cargoHash = "sha256-7P3bii0Y0hf3z9RCPIH6uClFIw/CTtUSzbTbaZNQkYQ=";

  doCheck = false;

  meta = {
    description = "Command line helpers for fuzzing";
    mainProgram = "cargo-fuzz";
    homepage = "https://github.com/rust-fuzz/cargo-fuzz";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
