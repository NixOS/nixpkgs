{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-pretty";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "romancitodev";
    repo = "cargo-pretty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AyvGh1sG+WIB/WVnDAt23lQz3IjoA1KU9FHdOT2c6XY=";
  };

  cargoHash = "sha256-zsADWe67rjkcXTwNPFMu+k8zEgdudca8cdX4N6vVECY=";

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo build wrapper with a live, animated status view";
    homepage = "https://crates.io/crates/cargo-pretty-build";
    downloadPage = "https://github.com/romancitodev/cargo-pretty/releases";
    changelog = "https://github.com/romancitodev/cargo-pretty/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ VZstless ];
    mainProgram = "cargo-pretty";
  };
})
