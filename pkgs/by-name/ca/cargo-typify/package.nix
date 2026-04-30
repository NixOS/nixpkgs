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
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = "typify";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tsZY+Ygh+9xOOAKcNh2U2k47o+uNAC2zguL+qW/wiqg=";
  };

  cargoHash = "sha256-K5Fj261Jh+NVipR71cYo5CqHx31czfgs6kr6uifHvaw=";

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
    maintainers = with lib.maintainers; [ iamanaws ];
  };
})
