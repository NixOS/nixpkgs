{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hongdown";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "dahlia";
    repo = "hongdown";
    tag = finalAttrs.version;
    hash = "sha256-JnfYBPWnZgZ7149yVsabP3n2+GnxR6ZvK0S+4w6x/c4=";
  };
  cargoHash = "sha256-Vn5dEaDnZ2FQ6ZlDKbbQ5lUvjyhIuhT2/xEaZ8KWmRA=";
  meta = {
    description = "Markdown formatter that enforces Hong Minhee's Markdown style conventions";
    mainProgram = "hongdown";
    homepage = "https://github.com/dahlia/hongdown";
    changelog = "https://github.com/dahlia/hongdown/blob/main/CHANGES.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wellmannmathis ];
  };
})
