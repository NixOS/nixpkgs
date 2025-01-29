{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-lock";
  version = "10.0.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Ui/Z4syhSxemV1R815R+yytDwN2YJBcHGscUYUp/0zE=";
  };

  cargoHash = "sha256-5Hg0y723wjV13rdEExK2II7EPpzAR29ZCqVgOeuJpO0=";

  buildFeatures = [ "cli" ];

  meta = with lib; {
    description = "Self-contained Cargo.lock parser with graph analysis";
    mainProgram = "cargo-lock";
    homepage = "https://github.com/rustsec/rustsec/tree/main/cargo-lock";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-lock/v${version}/cargo-lock/CHANGELOG.md";
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
