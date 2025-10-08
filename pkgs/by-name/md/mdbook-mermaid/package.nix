{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-mermaid";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "mdbook-mermaid";
    tag = "v${version}";
    hash = "sha256-Zn8jMlohSGlQFyKCUscS/jMiOU8kVzLva0GpHCMeOXc=";
  };

  cargoHash = "sha256-AgFSsEDtOE4HKhJbqC0y0R5G79jHksEnhKd5/humaK0=";

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
