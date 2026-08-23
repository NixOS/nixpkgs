{
  lib,
  rustPlatform,
  fetchFromSourcehut,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-depgraph";
  version = "1.6.0";

  src = fetchFromSourcehut {
    owner = "~jplatte";
    repo = "cargo-depgraph";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yvcKRESX2W1oLmQvkl07iG8+I74qDKsaS3amM4pZU8s=";
  };

  cargoHash = "sha256-5GFYp1ZEkmag2GfzHRz3QDYaURzbDKY9yTSznkxddnE=";

  meta = {
    description = "Create dependency graphs for cargo projects using `cargo metadata` and graphviz";
    mainProgram = "cargo-depgraph";
    homepage = "https://sr.ht/~jplatte/cargo-depgraph";
    changelog = "https://git.sr.ht/~jplatte/cargo-depgraph/tree/${finalAttrs.src.rev}/item/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})
