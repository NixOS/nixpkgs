{
  lib,
  rustfmt,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "cargo-typify";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = "typify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9acXyFXlTktL1BfrpqKvtw3DbwFjCh62HdniWff+ssU=";
  };

  cargoHash = "sha256-fIF3bbw7TOUAroTzhA/3qH4hfgiiPdW9Mk1Bucm/M3o=";

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
