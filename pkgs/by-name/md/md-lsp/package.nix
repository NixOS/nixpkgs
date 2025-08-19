{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "md-lsp";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "matkrin";
    repo = "md-lsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LUPZBDiS9jeUZ4r3BhZOK5SeOL7KuXu+Uy7CowzCdjo=";
  };

  cargoHash = "sha256-YS7ANZlxlRpl4ww/EJM57MTb+5WAW4mH6cQoziFCv18=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

  meta = {
    description = "Language server implementation for markdown files made in Rust";
    homepage = "https://github.com/matkrin/md-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mahyarmirrashed ];
    mainProgram = "md-lsp";
  };
})
