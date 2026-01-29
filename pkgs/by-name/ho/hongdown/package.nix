{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hongdown";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "dahlia";
    repo = "hongdown";
    tag = finalAttrs.version;
    hash = "sha256-POv+XGb7yq+KcaH22uDUiVa7IBErVK0E+DQlpdASoPw=";
  };
  cargoHash = "sha256-8g99laZgguGj7zYwXg4UFK1OxBM4dh3q/aArawZMaXs=";
  meta = {
    description = "Markdown formatter that enforces Hong Minhee's Markdown style conventions";
    mainProgram = "hongdown";
    homepage = "https://github.com/dahlia/hongdown";
    changelog = "https://github.com/dahlia/hongdown/blob/main/CHANGES.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wellmannmathis ];
  };
})
