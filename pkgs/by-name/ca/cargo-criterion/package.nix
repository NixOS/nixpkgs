{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-criterion";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bheisler";
    repo = "cargo-criterion";
    rev = version;
    sha256 = "sha256-RPix9DM6E32PhObvV3xPGrnXrrVHn3auxLUhysP8GM0=";
  };

  cargoHash = "sha256-D0Exfm6NRRedncDAgC3MgfagzsM0Dsc7X0i9arYYOgc=";

  meta = with lib; {
    description = "Cargo extension for running Criterion.rs benchmarks";
    mainProgram = "cargo-criterion";
    homepage = "https://github.com/bheisler/cargo-criterion";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [
      humancalico
      matthiasbeyer
    ];
  };
}
