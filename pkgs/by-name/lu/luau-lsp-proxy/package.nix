{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "luau-lsp-proxy";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "4teapo";
    repo = "luau-lsp-proxy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rbmFmJWlfYaQOKlzuwzk1Nd9cZwNGHtMUBwdRJbeWTM=";
  };

  cargoHash = "sha256-JchsOuABDgktisNySJgfkUtBC/7PM8WKI9E/LFP25n8=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doCheck = false;

  meta = {
    description = "Luau-lsp proxy that communicates with the companion plugin";
    homepage = "https://github.com/4teapo/luau-lsp-proxy";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ ];
    mainProgram = "luau-lsp-proxy";
  };
})
