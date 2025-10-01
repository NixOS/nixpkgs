{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-hack";
  version = "0.6.39";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-0+2bgjCgkZA8oYo5jkykB2US+LVVNo1tVk4smxYB6f4=";
  };

  cargoHash = "sha256-Pn7QL1D4WNMwCbXcm2bEdN2htIMwQhCsXrSaeeK2F7M=";

  # some necessary files are absent in the crate version
  doCheck = false;

  meta = {
    description = "Cargo subcommand to provide various options useful for testing and continuous integration";
    mainProgram = "cargo-hack";
    homepage = "https://github.com/taiki-e/cargo-hack";
    changelog = "https://github.com/taiki-e/cargo-hack/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
