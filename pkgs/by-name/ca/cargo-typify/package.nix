{
  lib,
  rustfmt,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-typify";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = "typify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FqTl2eTp2IgL+ADiHvn9SYEVksvSQ6xO4tHzvfDrNWY=";
  };

  cargoHash = "sha256-PWi8o+hgE/TKAsVqwbhurfsFdc2BOWD8C4VcjKeCCZY=";

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "JSON Schema to Rust type converter";
    homepage = "https://github.com/oxidecomputer/typify";
    changelog = "https://github.com/oxidecomputer/typify/blob/${finalAttrs.src.tag}/CHANGELOG.adoc";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "cargo-typify";
  };
})
