{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-swift";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "antoniusnaumann";
    repo = "cargo-swift";
    rev = "v${finalAttrs.version}";
    hash = "sha256-abLXt9wIw/qhSkusRSmHJHU8feojaLVQeFP8DAkE1Gc=";
  };

  cargoHash = "sha256-u4lzPbXyBCcZk5kzxuYHjtJQTTxjRYeDeMpIcK+Dr8Q=";

  meta = {
    description = "Cargo plugin to easily build Swift packages from Rust code";
    mainProgram = "cargo-swift";
    homepage = "https://github.com/antoniusnaumann/cargo-swift";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ elliot ];
  };
})
