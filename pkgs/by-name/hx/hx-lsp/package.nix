{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hx-lsp";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "erasin";
    repo = "hx-lsp";
    tag = finalAttrs.version;
    hash = "sha256-EsyGOIPRE39tPWzybcFLNymb+n9ZCdK/zyOgPYOHf+8=";
  };

  cargoHash = "sha256-fR5KUm1o10xHrwBv5pPWYe5hpGOp4QKoHZ2dQYlhDCY=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  meta = {
    description = "LSP tool providing custom code snippets and Code Actions for Helix Editor";
    homepage = "https://github.com/erasin/hx-lsp";
    changelog = "https://github.com/erasin/hx-lsp/releases/tag/${finalAttrs.version}";
    mainProgram = "hx-lsp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hadziqM ];
  };
})
