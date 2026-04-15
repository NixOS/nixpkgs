{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-diet";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "the-lean-crate";
    repo = "cargo-diet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-YjUO8UUXWZvZZZ2Y0py5LQdVBpq8jjwvGimVAWC8Gr8=";
  };

  cargoHash = "sha256-CnaeS7mh+QDPcQgeKzNV5Vey3zsiD10NdlfdQ1kcDB8=";

  meta = {
    description = "Help computing optimal include directives for your Cargo.toml manifest";
    mainProgram = "cargo-diet";
    homepage = "https://github.com/the-lean-crate/cargo-diet";
    changelog = "https://github.com/the-lean-crate/cargo-diet/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
