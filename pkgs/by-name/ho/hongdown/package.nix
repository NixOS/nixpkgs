{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hongdown";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "dahlia";
    repo = "hongdown";
    tag = finalAttrs.version;
    hash = "sha256-Bj0ECrYRnXSjgyblocnVjdYipuzbX2+G3KRWZvdR9Rk=";
  };
  cargoHash = "sha256-q84orbkrcKbO5FeI9dk0E92EtE9eQ8n/yGjXzh9MIgg=";
  meta = {
    description = "Markdown formatter that enforces Hong Minhee's Markdown style conventions";
    mainProgram = "hongdown";
    homepage = "https://github.com/dahlia/hongdown";
    changelog = "https://github.com/dahlia/hongdown/blob/main/CHANGES.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wellmannmathis ];
  };
})
