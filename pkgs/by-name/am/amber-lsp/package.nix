{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "amber-lsp";
  version = "0.1.18";

  src = fetchFromGitHub {
    owner = "amber-lang";
    repo = "amber-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pY8bKWDT0tFEkDsiwxxtbqj754pkbe/HomdMAIwwzgU=";
  };

  cargoHash = "sha256-KjFvK8rWR+sRlxYPWXNAaOKMjvcmtKyednQGkwacMKA=";

  nativeBuildInputs = [ makeWrapper ];

  postFixup = ''
    # By default it wants to write to $out/amber-lsp-resources
    wrapProgram $out/bin/amber-lsp \
      --run '
        export AMBER_LSP_RESOURCES_DIR="''${XDG_DATA_HOME:-$HOME/.local/share}/amber-lsp-resources"
      '
  '';

  meta = {
    description = "Official language server for the Amber programming language";
    mainProgram = "amber-lsp";
    homepage = "https://github.com/amber-lang/amber-lsp";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ tye-exe ];
  };
})
