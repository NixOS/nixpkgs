{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-outdated";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "kbknapp";
    repo = "cargo-outdated";
    rev = "v${version}";
    hash = "sha256-ey11ANSflWGnCsn6M9GupgC4DE5mWww6vw5pK0CFdLo=";
  };

  cargoHash = "sha256-PYlVXGfitsjEGiw07L5b+L8pfxvtkHshIjTXeuPUTdk=";

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
