{
  lib,
  rustfmt,
  rustPlatform,
  fetchFromGitHub,
  gitUpdater,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-typify";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = "typify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ym3xPMn36+Y8dnImmuegjwrARPzozhwI+qhDCXmFsHg=";
  };

  cargoHash = "sha256-3hh4M5cqwLDHcHI+YGKXQOeTXGcVTec+xk+mZcVp0IU=";

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

  meta = {
    description = "JSON Schema to Rust type converter";
    homepage = "https://github.com/oxidecomputer/typify";
    changelog = "https://github.com/oxidecomputer/typify/blob/${finalAttrs.src.tag}/CHANGELOG.adoc";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "cargo-typify";
  };
})
