{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-readme";
  version = "3.3.2";

  src = fetchFromGitHub {
    owner = "webern";
    repo = "cargo-readme";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-p8QQNACU9lFig0vBQrb1u2T44Icwk10OBjGzaVLj7kk=";
  };

  cargoHash = "sha256-kfXDMBqS4/QC+khQhQ2Jrer8TuFKlnZFS3IZ2lcVOR8=";

  # disable doc tests
  cargoTestFlags = [
    "--bins"
    "--lib"
  ];

  meta = {
    description = "Generate README.md from docstrings";
    mainProgram = "cargo-readme";
    homepage = "https://github.com/livioribeiro/cargo-readme";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      baloo
      matthiasbeyer
    ];
  };
})
