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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = "typify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1JnNNapIg0uholQkgnqU+KQ1q1SCF0MJmrO8XybxBzw=";
  };

  cargoHash = "sha256-tH6Unl9mFUmpIiDoHp7ZUwaKAK8QEWGf2ldKbcyBET0=";

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
    homepage = "https://github.com/oxidecomputer/typify";
    changelog = "https://github.com/oxidecomputer/typify/blob/${finalAttrs.src.tag}/CHANGELOG.adoc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "cargo-typify";
  };
})
