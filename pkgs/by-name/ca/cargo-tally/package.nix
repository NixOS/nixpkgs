{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.62";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-EZvwjxIw6ixaSvHod7l9178D7MRTk4MrWHPxy+UCgf4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-aSOEaHlUeP8D0GDdI6iLnuRHFasTt1nM6EGzYxhIPvo=";

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
