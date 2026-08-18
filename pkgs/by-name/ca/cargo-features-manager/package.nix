{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-features-manager";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "ToBinio";
    repo = "cargo-features-manager";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ay6nhRmGRBURisfr7qnnWCKn8JCnFh9x0TJ7vK2p4PU=";
  };

  cargoHash = "sha256-QB+0ezc7IQPzSym/Lfqjnh24tHKKwLqIpnGPNFQxI5M=";

  meta = {
    description = "TUI-like cli tool to manage the features of your rust-projects dependencies";
    homepage = "https://github.com/ToBinio/cargo-features-manager";
    changelog = "https://github.com/ToBinio/cargo-features-manager/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
    mainProgram = "cargo-features";
  };
})
