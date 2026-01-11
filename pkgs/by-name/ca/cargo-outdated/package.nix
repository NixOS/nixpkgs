{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "kbknapp";
    repo = "cargo-outdated";
    rev = "v${version}";
    hash = "sha256-r7FtuXx9+OmVAdL6+9s2bYHjsURmX60+2c7+2FjkSRs=";
  };

  cargoHash = "sha256-l4UfmntTRlqRq1040FTzAn/QU33+owv569tcWNXSGN0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = {
    description = "Cargo subcommand for displaying when Rust dependencies are out of date";
    mainProgram = "cargo-outdated";
    homepage = "https://github.com/kbknapp/cargo-outdated";
    changelog = "https://github.com/kbknapp/cargo-outdated/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      ivan
      matthiasbeyer
    ];
  };
}
