{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "kittycad-kcl-lsp";
  version = "0.1.61";

  src = fetchFromGitHub {
    owner = "KittyCAD";
    repo = "kcl-lsp";
    rev = "refs/tags/v${version}";
    hash = "sha256-VtrR4v0BJWYdoYFDJpWnmVqDhZMlPGm+g9yjxYfcFxQ=";
  };

  cargoHash = "sha256-51eFOJnc/GqgXtfVx/omR+KuC7x/oKGGR+s0z6nKXBg=";

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
