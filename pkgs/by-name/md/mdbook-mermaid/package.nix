{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "mdbook-mermaid";
    tag = "v${version}";
    hash = "sha256-RbicO3TN7cnfm71OdsVbehgA5LJ1EHE26nXg0Gh1U6o=";
  };

  cargoHash = "sha256-WMPk/UPNfNXjJKUcczbQPOy9bwy2ZSR5DPmvwtcJ5ys=";

  meta = {
    description = "Preprocessor for mdbook to add mermaid.js support";
    mainProgram = "mdbook-mermaid";
    homepage = "https://github.com/badboy/mdbook-mermaid";
    changelog = "https://github.com/badboy/mdbook-mermaid/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      xrelkd
      matthiasbeyer
    ];
  };
}
