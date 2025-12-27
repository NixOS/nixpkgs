{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "just-lsp";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "terror";
    repo = "just-lsp";
    tag = finalAttrs.version;
    hash = "sha256-VA6rUcOc/O4KocefxGr4BFnGSb1Gv8+UObtHua/6lbg=";
  };

  cargoHash = "sha256-t+a24rBEHLgnrADRzMtrZHdeQ2tDxHK/bMzYidLPNQw=";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Language server for just";
    homepage = "https://github.com/terror/just-lsp";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "just-lsp";
  };
})
