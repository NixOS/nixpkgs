{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "kittycad-kcl-lsp";
  version = "0.1.66";

  src = fetchFromGitHub {
    owner = "KittyCAD";
    repo = "kcl-lsp";
    tag = "v${version}";
    hash = "sha256-uKsxWNR5syd2+/4I9nxZ+fWBUdHP3rhpUzLVPn4v8Wk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-dKNuPg6XRZ6UwZr6+S3+LM3t9xATgGndhX3hrD3Xp0Q=";

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
