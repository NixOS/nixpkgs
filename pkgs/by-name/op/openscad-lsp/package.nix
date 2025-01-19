{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "openscad-lsp";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "Leathong";
    repo = "openscad-LSP";
    rev = "dc1283df080b981f8da620744b0fb53b22f2eb84";
    hash = "sha256-IPTBWX0kKmusijg4xAvS1Ysi9WydFaUWx/BkZbMvgJk=";
  };

  cargoHash = "sha256-AQpjamyHienqB501lruxk56N6r8joocWrJ5srsm5baY=";

  # no tests exist
  doCheck = false;

  meta = {
    description = "LSP (Language Server Protocol) server for OpenSCAD";
    mainProgram = "openscad-lsp";
    homepage = "https://github.com/Leathong/openscad-LSP";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ c-h-johnson ];
  };
}
