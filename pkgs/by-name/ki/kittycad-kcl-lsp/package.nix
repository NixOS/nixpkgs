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
    tag = "v${version}";
    hash = "sha256-3j7xiTrhDPBNTg53y2KyLpk8m4DrJbZWYkdIm5sxEfs=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Hab3DlLU2PRaZCBA2BM5FlpDkpXIfIFxys6uPCDUrnc=";

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
