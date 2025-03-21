{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.60";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-d1nl3Gnk5huejUriwo1Q3+F6htIBe+uC36sDEXO5SGY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-XJZtOK+0+GJ1qM9OR/Z/764BfM+9VTYxBA9eOCHu4ms=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk_11_0.frameworks;
    [
      DiskArbitration
      Foundation
      IOKit
    ]
  );

  meta = with lib; {
    description = "Graph the number of crates that depend on your crate over time";
    mainProgram = "cargo-tally";
    homepage = "https://github.com/dtolnay/cargo-tally";
    changelog = "https://github.com/dtolnay/cargo-tally/releases/tag/${version}";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      figsoda
      matthiasbeyer
    ];
  };
}
