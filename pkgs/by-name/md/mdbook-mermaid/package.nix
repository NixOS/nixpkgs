{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-mermaid";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "mdbook-mermaid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hcvX664QoM1wo7oHM68O7rmH+KAkrQZvtXQiwWmm+e8=";
  };

  cargoHash = "sha256-9uE3Xb4LhzGoB9lcusvyKm28X0uvgYVRzIju+Ozlc6A=";

  meta = {
    description = "Preprocessor for mdbook to add mermaid.js support";
    mainProgram = "mdbook-mermaid";
    homepage = "https://github.com/badboy/mdbook-mermaid";
    changelog = "https://github.com/badboy/mdbook-mermaid/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      xrelkd
      matthiasbeyer
    ];
  };
})
