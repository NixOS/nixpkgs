{
  lib,
  rustfmt,
  rustPlatform,
  fetchFromGitHub,
  gitUpdater,
  makeWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-typify";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = "typify";
    rev = "v${version}";
    hash = "sha256-vokhWIY5iikTyADrqxp6DIq+tJ+xdFPebDFTddJnstA=";
  };

  cargoHash = "sha256-1qxWFyA9xCnyDES27uj7gDc5Nf6qdikNkpuf/DP/NAU=";

  nativeBuildInputs = [
    rustfmt
    makeWrapper
  ];

  cargoBuildFlags = [
    "--package"
    "cargo-typify"
  ];
  cargoTestFlags = [
    "--package"
    "cargo-typify"
  ];

  strictDeps = true;

  preCheck = ''
    # cargo-typify depends on rustfmt-wrapper, which requires RUSTFMT:
    export RUSTFMT="${lib.getExe rustfmt}"
  '';

  postInstall = ''
    wrapProgram $out/bin/cargo-typify \
      --set RUSTFMT "${lib.getExe rustfmt}"
  '';

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "JSON Schema to Rust type converter";
    mainProgram = "cargo-typify";
    homepage = "https://github.com/oxidecomputer/typify";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ david-r-cox ];
  };
}
