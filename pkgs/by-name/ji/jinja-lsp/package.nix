{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "jinja-lsp";
  version = "0.1.81";

  src = fetchCrate {
    inherit version;
    crateName = "jinja-lsp";
    hash = "sha256-2xXztfLpE7ikE7ICUZVp//6tt9K0ILRFOmFLyH7DLsQ=";
  };

  cargoHash = "sha256-vMoDbUDImDp+DPjS0rfJD9hYUa79bKsDUyAhAZvEyxA=";

  meta = with lib; {
    description = "Language server for Jinja";
    longDescription = "jinja-lsp enhances minijinja development experience by providing Helix/Nvim users with advanced features such as autocomplete, syntax highlighting, hover, goto definition, code actions and linting.";
    homepage = "https://github.com/uros-5/jinja-lsp";
    changelog = "https://github.com/uros-5/jinja-lsp/releases";
    license = licenses.mit;
    maintainers = with maintainers; [ lytedev ];
    mainProgram = "jinja-lsp";
  };
}
