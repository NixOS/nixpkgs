{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-diet";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "the-lean-crate";
    repo = "cargo-diet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xnsrdOOngflFzQhkfIftI0hk6XYRDyoMPtivN53aRpg=";
  };

  cargoHash = "sha256-nh+8KDK2zPMjh2VA4LdBK+ALL+hbKU+yYx6KdPGxNbU=";

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
