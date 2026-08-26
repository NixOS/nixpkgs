{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-careful";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "RalfJung";
    repo = "cargo-careful";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xnAPMSMpdnFF6hUU+SR+kyWsLNuD2dXYp0/qDF8QRfA=";
  };

  cargoHash = "sha256-UiN2cWqwn+sJ56pODBilirw6jVnVz+rIsPuYVaNaSfM=";

  meta = {
    description = "Tool to execute Rust code carefully, with extra checking along the way";
    mainProgram = "cargo-careful";
    homepage = "https://github.com/RalfJung/cargo-careful";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
