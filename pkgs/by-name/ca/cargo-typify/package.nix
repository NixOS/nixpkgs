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
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "oxidecomputer";
    repo = "typify";
    rev = "v${finalAttrs.version}";
    hash = "sha256-czVxvsRhKnNnvPmONF+pTzZG1tizfCCbThgPhaI8TLo=";
  };

  cargoHash = "sha256-7z/gWIl2HqEkpRcWXZv6QQmLdJVJQfY7VCVP2ik5Mps=";

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
    maintainers = [ ];
  };
})
