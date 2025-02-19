{
  lib,
  rustPlatform,
  fetchCrate,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-tally";
  version = "1.0.58";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-a9Mgsxe3vNtvuqMJIm7nRL2aiYYzpArz7R5XQcZAUxc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3ZlF3FyWzcVL/ZMqId3wY//UzV7LeoJJdftb0IIC7Vk=";

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
