{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "mdbook-mermaid";
    tag = "v${version}";
    hash = "sha256-+Dk3wW1pLWVfJy+OC648BQ5rZrHYqPdjV2hfJSIV6m0=";
  };

  cargoHash = "sha256-LbDlxQ2sbyYlXOzvA+9tLRxqGGxtgQ9KujsD7UBzskM=";

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
