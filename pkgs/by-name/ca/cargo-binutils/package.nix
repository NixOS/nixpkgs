{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-binutils";
  version = "0.4.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-AF1MRBH8ULnHNHT2FS/LxMH+b06QMTIZMIR8mmkn17c=";
  };

  cargoHash = "sha256-pK6pFgOxQdEc4hYFj6mLEiIuPhoutpM2h3OLZgYrf6Q=";

  meta = {
    description = "Cargo subcommands to invoke the LLVM tools shipped with the Rust toolchain";
    longDescription = ''
      In order for this to work, you either need to run `rustup component add llvm-tools` or install the `llvm-tools` component using your Nix library (e.g. fenix or rust-overlay)
    '';
    homepage = "https://github.com/rust-embedded/cargo-binutils";
    changelog = "https://github.com/rust-embedded/cargo-binutils/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [
      stupremee
      matthiasbeyer
      newam
    ];
  };
}
