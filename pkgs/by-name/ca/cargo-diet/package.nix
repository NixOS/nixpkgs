{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-diet";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "the-lean-crate";
    repo = "cargo-diet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/f5GbNWkx/pOQgsaxg+HeI4Z9joX3pCL8u4Pu7VZg08=";
  };

  cargoHash = "sha256-PK5Ru/Slz1MTD9DxVY0zratzAeXAokJZ+Kz/MznaeB0=";

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
