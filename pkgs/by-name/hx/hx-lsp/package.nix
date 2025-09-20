{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hx-lsp";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "erasin";
    repo = "hx-lsp";
    tag = finalAttrs.version;
    hash = "sha256-wTilbEK3BZehklAd+3SS2tW/vc8WEeMPUsYdDVRC/Ho=";
  };

  cargoHash = "sha256-dcGInrfWftClvzrxYZvrazm+IWWRfOZmxDJPKwu7GwM=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  meta = {
    description = "lsp for helix , support snippets, actions";
    homepage = "https://github.com/erasin/hx-lsp";
    changelog = "https://github.com/erasin/hx-lsp/releases/tag/${finalAttrs.version}";
    mainProgram = "hx-lsp";
    license = lib.licenses.mit;

    maintainers = with lib.maintainers; [ hadziqM ];
  };
})
