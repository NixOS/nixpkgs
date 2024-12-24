{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "kittycad-kcl-lsp";
  version = "0.1.65";

  src = fetchFromGitHub {
    owner = "KittyCAD";
    repo = "kcl-lsp";
    rev = "refs/tags/v${version}";
    hash = "sha256-3j7xiTrhDPBNTg53y2KyLpk8m4DrJbZWYkdIm5sxEfs=";
  };

  cargoHash = "sha256-t7YnOnls0PZM2iTmmkBFt1WmFvqiY4eS8LBf0tvinJg=";

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "KittyCAD KCL language server";
    changelog = "https://github.com/KittyCAD/kcl-lsp/releases/tag/v${version}";
    homepage = "https://github.com/KittyCAD/kcl-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jljox ];
    mainProgram = "kittycad-kcl-lsp";
  };
}
