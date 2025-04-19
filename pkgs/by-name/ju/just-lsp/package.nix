{
  fetchCrate,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "just-lsp";
  version = "0.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-k8wb2A5f9LaE2mt/E+XugaWYuR9xFsWBhPw9guuYjbU=";
  };

  cargoHash = "sha256-qPMtYaCvSAnLXrLX20QKbgXo9L1HYxJW4uZIzXhpD/A=";

  meta = {
    homepage = "https://github.com/terror/just-lsp";
    description = "language server for just";
    license = lib.licenses.cc0;
    mainProgram = "just-lsp";
    maintainers = with lib.maintainers; [ vuimuich ];
  };
}
