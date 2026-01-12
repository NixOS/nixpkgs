{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "mdbook-mermaid";
    tag = "v${version}";
    hash = "sha256-9aiu3mQaRgVVhtX/v2hMPzclnVQIhUz4gVy0Xc84zO8=";
  };

  cargoHash = "sha256-MDtXgNiN4tVgP/98fbcL9WQXAJire+c3lmnc12KhQ50=";

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
