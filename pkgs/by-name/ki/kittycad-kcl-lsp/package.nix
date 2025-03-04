{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "kittycad-kcl-lsp";
  version = "0.1.69";

  src = fetchFromGitHub {
    owner = "KittyCAD";
    repo = "kcl-lsp";
    tag = "v${version}";
    hash = "sha256-qMVzOck0PgdphAAqXrrzC0gnxQXfzCa/3KEBnWB19mE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-y36Xft21NkdlcLuxQRRENjAOW128+rcc47uUmB9wPVc=";

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
